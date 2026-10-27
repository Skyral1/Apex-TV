import 'package:flutter/material.dart';

/// Couleurs principales d'un thème Apex-TV.
///
/// Toutes les couleurs sont stockées au format `#RRGGBB` ou `#AARRGGBB`
/// dans le fichier `.apextheme`.
class ApexThemeColors {
  const ApexThemeColors({
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
    required this.textMuted,
    required this.border,
  });

  final Color accent;
  final Color background;
  final Color surface;
  final Color text;
  final Color textMuted;
  final Color border;

  factory ApexThemeColors.fromJson(Map<String, dynamic> json) {
    return ApexThemeColors(
      accent: _parseColor(json['accent'], defaultValue: 0xFF7C5CFF),
      background: _parseColor(json['background'], defaultValue: 0xFF000000),
      surface: _parseColor(json['surface'], defaultValue: 0xFF101014),
      text: _parseColor(json['text'], defaultValue: 0xFFF2F2F7),
      textMuted: _parseColor(json['textMuted'], defaultValue: 0xFF9E9EAA),
      border: _parseColor(json['border'], defaultValue: 0xFF2A2A33),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accent': _colorToHex(accent),
      'background': _colorToHex(background),
      'surface': _colorToHex(surface),
      'text': _colorToHex(text),
      'textMuted': _colorToHex(textMuted),
      'border': _colorToHex(border),
    };
  }

  ApexThemeColors copyWith({
    Color? accent,
    Color? background,
    Color? surface,
    Color? text,
    Color? textMuted,
    Color? border,
  }) {
    return ApexThemeColors(
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
    );
  }

  static Color _parseColor(dynamic value, {required int defaultValue}) {
    if (value is! String || value.isEmpty) {
      return Color(defaultValue);
    }

    final normalized = value.replaceFirst('#', '').trim();

    if (normalized.length == 6) {
      return Color(int.parse('FF$normalized', radix: 16));
    }

    if (normalized.length == 8) {
      return Color(int.parse(normalized, radix: 16));
    }

    return Color(defaultValue);
  }

  static String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}