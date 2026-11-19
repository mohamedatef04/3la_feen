import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utility class to generate custom emoji markers for the map
class MarkerUtils {
  MarkerUtils._();

  static BitmapDescriptor? _carMarker;
  static BitmapDescriptor? _personMarker;
  static BitmapDescriptor? _stationMarker;
  static BitmapDescriptor? _pickupMarker;

  /// Initialize all markers. Call this once at app start.
  static Future<void> init() async {
    _carMarker = await _createEmojiMarker('🚗', size: 60);
    _personMarker = await _createEmojiMarker('🧑', size: 55);
    _stationMarker = await _createEmojiMarker('📍', size: 55);
    _pickupMarker = await _createEmojiMarker('🟢', size: 40);
  }

  /// Get car marker for driver location
  static BitmapDescriptor get carMarker =>
      _carMarker ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

  /// Get person marker for passenger pickup location
  static BitmapDescriptor get personMarker =>
      _personMarker ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

  /// Get station marker for destination
  static BitmapDescriptor get stationMarker =>
      _stationMarker ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

  /// Get pickup marker (green circle)
  static BitmapDescriptor get pickupMarker =>
      _pickupMarker ??
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

  /// Create a BitmapDescriptor from an emoji
  static Future<BitmapDescriptor> _createEmojiMarker(
    String emoji, {
    double size = 50,
  }) async {
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: emoji,
      style: TextStyle(fontSize: size),
    );
    textPainter.layout();

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    textPainter.paint(canvas, Offset.zero);

    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );
    final ByteData? byteData = await img.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.bytes(
      byteData!.buffer.asUint8List(),
      bitmapScaling: MapBitmapScaling.none,
    );
  }

  /// Create a custom marker on-the-fly (for dynamic needs)
  static Future<BitmapDescriptor> createCustomMarker(
    String emoji, {
    double size = 50,
  }) async {
    return await _createEmojiMarker(emoji, size: size);
  }
}
