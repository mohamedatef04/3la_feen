# 3la Feen (على فين)

[![CI](https://github.com/mohamedatef04/3la_feen/actions/workflows/ci.yml/badge.svg)](https://github.com/mohamedatef04/3la_feen/actions/workflows/ci.yml)

A ride-hailing app for Egypt, built with Flutter and Supabase. Passengers post a trip, nearby drivers send price offers, the passenger picks one, and both sides follow the trip live on the map until it ends with a rating.

One codebase serves both roles: the app opens the passenger or the driver experience depending on the signed-in account.

## Features

**Passenger**
- Search for pickup and drop-off places (OpenStreetMap / Nominatim)
- Route and distance on the map (OSRM), drawn as a polyline
- Send a trip request and receive driver price offers in real time
- Accept an offer, then track the driver's live location
- Cancel a trip, rate the driver when the trip completes
- Chat with the driver during the trip

**Driver**
- Go online/offline and receive nearby trip requests as a live stream
- Send a price offer on a request
- Active-trip map with live location sharing
- Trip history, ratings received, notifications, account screen

**Shared**
- Email auth: register, login, forgot/reset password, logout
- Push notifications (Firebase Cloud Messaging + local notifications), including chat messages
- Arabic (default, RTL) and English, light and dark themes, dark map style

## Architecture

Feature-first Clean Architecture with Cubit for state management.

```
lib/
├── core/                  # shared: DI, routing, theme, network, errors, services, widgets
│   ├── di/                # get_it service locator
│   ├── routes/            # go_router configuration
│   ├── services/          # live location tracking, chat notifications
│   └── errors/            # Failures returned through dartz Either
└── features/
    ├── auth/              # data (data source, models, repo) + presentation (cubits, screens, widgets)
    ├── get_started/
    ├── chat/
    └── home/
        ├── passenger/     # data + presentation (one cubit per use case)
        └── driver/        # data + services + presentation
```

- **Data layer:** repositories return `Either<Failures, T>`. Supabase is used for auth, the database and realtime streams. Dio is used for the Nominatim and OSRM HTTP calls.
- **Presentation:** each screen action has its own small Cubit (for example `SendTripRequestCubit`, `GetPricesOffersCubit`, `TrackDriverCubit`, `TripActionCubit`).
- **Realtime:** trips, offers, driver locations and chat messages are Supabase realtime streams.
- **Backend logic:** `supabase/functions/notify_passenger` is a Supabase Edge Function. A database webhook calls it when a driver makes an offer, and it sends the passenger a push notification through Firebase Admin.

### Main tables (Supabase)

`users`, `trips`, `offers`, `driver_locations`, `chat_messages`, `notifications`, `trip_ratings` (the schema is in `supabase/trip_ratings_schema.sql`)

## Tech stack

Flutter · Dart 3.10 · flutter_bloc · get_it · go_router · dartz · Supabase · Firebase Messaging · google_maps_flutter · location · Dio · easy_localization · flutter_screenutil

## Getting started

1. Install Flutter (stable, Dart ≥ 3.10).
2. Copy the env template and fill in your own values:
   ```bash
   cp .env.example .env
   ```
3. Add your own Firebase config (`android/app/google-services.json`, `lib/firebase_options.dart`) with `flutterfire configure`, and put a Google Maps API key in `AndroidManifest.xml`.
4. Run:
   ```bash
   flutter pub get
   flutter run
   ```

> `.env` is bundled into the app as an asset, so only put client-safe values in it (Supabase URL and anon key). Never put service-role keys or CI tokens there.

## Releasing (Firebase App Distribution)

Android builds go out through fastlane. Put `FIREBASE_TOKEN` in `android/fastlane/.env` (git-ignored), then:

```bash
cd android
bundle install
bundle exec fastlane distribute
```

## Tests

```bash
flutter test
```

## Status

The app is in active development. Payments and an admin dashboard are not built yet.
