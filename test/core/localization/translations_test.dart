import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Flattens nested JSON into dotted keys: {"a": {"b": "x"}} -> {"a.b": "x"}.
Map<String, String> flatten(Map<String, dynamic> json, [String prefix = '']) {
  final out = <String, String>{};
  json.forEach((key, value) {
    final path = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map<String, dynamic>) {
      out.addAll(flatten(value, path));
    } else {
      out[path] = value.toString();
    }
  });
  return out;
}

Map<String, String> load(String lang) => flatten(
  jsonDecode(File('assets/lang/$lang.json').readAsStringSync())
      as Map<String, dynamic>,
);

Set<String> placeholders(String text) =>
    RegExp(r'\{(\w+)\}').allMatches(text).map((m) => m.group(1)!).toSet();

void main() {
  final ar = load('ar');
  final en = load('en');

  test('Arabic and English define the same keys', () {
    expect(
      ar.keys.toSet().difference(en.keys.toSet()),
      isEmpty,
      reason: 'keys missing from en.json',
    );
    expect(
      en.keys.toSet().difference(ar.keys.toSet()),
      isEmpty,
      reason: 'keys missing from ar.json',
    );
  });

  test('no translation is empty', () {
    for (final entry in [...ar.entries, ...en.entries]) {
      expect(entry.value.trim(), isNotEmpty, reason: entry.key);
    }
  });

  test('both languages use the same placeholders for each key', () {
    for (final key in ar.keys) {
      expect(
        placeholders(en[key]!),
        placeholders(ar[key]!),
        reason: 'placeholders differ for "$key"',
      );
    }
  });

  test('every key used in lib/ exists in the translations', () {
    final used = <String>{};
    final keyPattern = RegExp(r"""'([a-z_]+\.[a-z_.]+)'\.tr\(""");
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        used.addAll(
          keyPattern
              .allMatches(file.readAsStringSync())
              .map((m) => m.group(1)!),
        );
      }
    }

    expect(used, isNotEmpty);
    expect(used.difference(ar.keys.toSet()), isEmpty);
  });
}
