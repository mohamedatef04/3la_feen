// Follow this setup guide to integrate the Deno runtime into your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import admin from 'npm:firebase-admin@11.10.1'

// Define the shape of the payload we expect from the Database Webhook
interface WebhookPayload {
    type: 'INSERT' | 'UPDATE' | 'DELETE'
    table: string
    record: {
        id: number
        trip_id: string
        driver_id: string
        offer: number
    }
    schema: string
    old_record: null | any
}

// Initialize Firebase Admin (will be done once)
let rawSecret = Deno.env.get('FIREBASE_SERVICE_ACCOUNT') || '{}'
rawSecret = rawSecret.trim().replace(/^['"]|['"]$/g, '')

// Detect if it's Base64 (doesn't start with {) and decode it
if (!rawSecret.startsWith('{') && rawSecret !== '{}' && rawSecret.length > 20) {
    try {
        console.log('Detected Base64 secret, decoding...')
        // Use the built-in Deno Base64 decoder
        const binary = Uint8Array.from(atob(rawSecret), c => c.charCodeAt(0))
        rawSecret = new TextDecoder().decode(binary)
    } catch (e) {
        console.error('Failed to decode Base64 secret. Ensure it is a valid Base64 string.')
    }
}

const serviceAccount = JSON.parse(rawSecret)

if (serviceAccount.project_id && admin.apps.length === 0) {
    let key = serviceAccount.private_key
    if (key) {
        // Replace literal \n with real newlines and strip any accidental quotes
        key = key.replace(/\\n/g, '\n').replace(/"/g, '').trim()
    }

    admin.initializeApp({
        credential: admin.credential.cert({
            projectId: serviceAccount.project_id,
            clientEmail: serviceAccount.client_email,
            privateKey: key,
        }),
        projectId: serviceAccount.project_id,
    })
} else if (admin.apps.length > 0) {
    console.log('Firebase Admin already initialized')
} else {
    console.error('Missing or invalid FIREBASE_SERVICE_ACCOUNT secret.')
}

serve(async (req: any) => {
    console.log('--- Notify Passenger Function Start ---')
    try {
        const payload: WebhookPayload = await req.json()
        console.log('Webhook Payload:', JSON.stringify(payload))

        if (payload.table !== 'offers') {
            return new Response(`Wrong table: ${payload.table}`, { status: 200 })
        }

        const record = payload.record
        const trip_id = record.trip_id
        const offer_amount = record.offer

        console.log(`Debug Info: trip_id=${trip_id}, offer=${offer_amount}`)

        if (!trip_id) {
            console.error('Missing trip_id in record')
            return new Response('Missing trip_id', { status: 400 })
        }

        const supabaseUrl = Deno.env.get('SUPABASE_URL')!
        const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
        const supabase = createClient(supabaseUrl, supabaseKey)

        // 1. Fetch Trip
        console.log(`Fetching trip: ${trip_id}`)
        const { data: trip, error: tripError } = await supabase
            .from('trips')
            .select('passenger_id')
            .eq('id', trip_id)
            .single()

        if (tripError || !trip) {
            console.error('Trip fetch error:', JSON.stringify(tripError))
            return new Response('Trip not found', { status: 200 })
        }

        const passengerId = trip.passenger_id
        console.log(`Found passengerId: ${passengerId}`)

        if (!passengerId) {
            console.error('No passenger_id for this trip')
            return new Response('No passenger id', { status: 200 })
        }

        // 2. Fetch User Token
        const { data: user, error: userError } = await supabase
            .from('users')
            .select('fcm_token')
            .eq('id', passengerId)
            .single()

        if (userError || !user) {
            console.error('User fetch error:', JSON.stringify(userError))
            return new Response('User token not found', { status: 200 })
        }

        const token = user.fcm_token
        console.log(`FCM Token found: ${token ? 'YES' : 'NO'}`)

        if (!token) {
            return new Response('User has no token', { status: 200 })
        }

        // 3. Send Notification
        const message = {
            notification: {
                title: 'عرض جديد',
                body: `تم اقتراح عرض جديد لك بقيمه ${offer_amount} جنيه`,
            },
            data: {
                trip_id: String(trip_id),
            },
            token: token,
        }

        console.log('Sending to FCM...')
        const response = await admin.messaging().send(message)
        console.log('FCM Success:', response)

        return new Response(JSON.stringify({ success: true, response }), {
            headers: { 'Content-Type': 'application/json' },
            status: 200,
        })

    } catch (err: any) {
        console.error('CRITICAL ERROR:', err.message)
        return new Response(JSON.stringify({ error: err.message }), {
            headers: { 'Content-Type': 'application/json' },
            status: 500,
        })
    }
})
