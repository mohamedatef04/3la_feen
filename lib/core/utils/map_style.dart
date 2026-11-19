import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Loads the Google Maps JSON style that matches the app theme.
abstract final class MapStyle {
  static const _dark = 'assets/map_styles/dark_map_style.json';
  static const _light = 'assets/map_styles/light_map_style.json';

  /// Returns the style JSON, or null (default map look) if it can't be read.
  static Future<String?> load(Brightness brightness) async {
    try {
      return await rootBundle.loadString(
        brightness == Brightness.dark ? _dark : _light,
      );
    } catch (e) {
      debugPrint('Error loading map style: $e');
      return null;
    }
  }
}
