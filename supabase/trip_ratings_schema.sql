-- Supabase SQL: Create trip_ratings table for driver ratings
-- Run this in your Supabase SQL Editor

CREATE TABLE IF NOT EXISTS trip_ratings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trip_id UUID NOT NULL,
  driver_id UUID NOT NULL,
  passenger_id UUID NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add index for faster queries
CREATE INDEX IF NOT EXISTS idx_trip_ratings_driver_id ON trip_ratings(driver_id);
CREATE INDEX IF NOT EXISTS idx_trip_ratings_trip_id ON trip_ratings(trip_id);

-- Enable Row Level Security
ALTER TABLE trip_ratings ENABLE ROW LEVEL SECURITY;

-- Policy: Users can insert their own ratings
CREATE POLICY "Users can insert ratings" ON trip_ratings
  FOR INSERT WITH CHECK (auth.uid() = passenger_id);

-- Policy: Users can view ratings for their trips
CREATE POLICY "Users can view relevant ratings" ON trip_ratings
  FOR SELECT USING (
    auth.uid() = passenger_id OR 
    auth.uid() = driver_id
  );
