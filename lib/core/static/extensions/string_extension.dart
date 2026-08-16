import 'package:flutter/material.dart';

extension StringEx on String {
  String showUntil(int end, [int start = 0]) {
    return length >= end ? '${substring(start, end)}...' : this;
  }

  String ifEmpty([String onEmpty = 'EMPTY']) {
    return isEmpty ? onEmpty : this;
  }

  String when(bool condition, {String onFalse = '', bool addSpace = true}) {
    return condition ? (addSpace ? ' $this' : this) : onFalse;
  }

  bool get isValidEmail {
    final reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return reg.hasMatch(this);
  }

  String get low => toLowerCase();
  String get up => toUpperCase();

  String decodeUri() => Uri.decodeFull(this);
  String encodeUri() => Uri.encodeFull(this);

  /// Tries to convert this String (hex color) into a Flutter Color.
  /// Returns null if conversion fails.
  Color? tryParseColor() {
    if (trim().isEmpty) return null;

    try {
      String hex = replaceAll('#', '').replaceAll('0x', '');

      hex = hex.padLeft(6, '0');
      hex = hex.padLeft(8, 'F');

      final value = int.parse('0x$hex');
      return Color(value);
    } catch (_) {
      return null;
    }
  }
}

extension NullableStringEx on String? {
  /// true if null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// true if not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// true if null, empty, or only whitespace
  bool get isBlank => this == null || this!.trim().isEmpty;

  /// true if contains non-whitespace characters
  bool get isNotBlank => !isBlank;

  /// returns empty string if null
  String get orEmpty => this ?? '';

  /// returns null if empty
  String? get nullIfEmpty => (this?.isEmpty ?? true) ? null : this;

  /// returns null if blank
  String? get nullIfBlank =>
      (this == null || this!.trim().isEmpty) ? null : this;

  /// trimmed value or empty string
  String get trimmed => this?.trim() ?? '';

  /// trimmed value or null
  String? get trimmedOrNull {
    final v = this?.trim();
    return (v == null || v.isEmpty) ? null : v;
  }

  /// safe length
  int get safeLength => this?.length ?? 0;

  /// returns default value if null
  String or(String fallback) => this ?? fallback;

  /// returns default if null or empty
  String orIfEmpty(String fallback) =>
      (this == null || this!.isEmpty) ? fallback : this!;
}
