import 'package:flutter/material.dart';

/// Style du focus D-pad appliqué aux tuiles et éléments navigables.
enum ApexFocusStyleType {
  border,
  glow,
  doubleBorder,
  borderAndGlow,
}

class ApexThemeFocus {
  const ApexThemeFocus({
    required this.type,
    required this.color,
    required this.borderWidth,
    required this.glowIntensity,
    required this.cornerRadius,
    required this.scale,
  });

  final ApexFocusStyleType type;
  final Color color;
  final double borderWidth;
  final double glowIntensity;
  final double cornerRadius;
  final double scale;

  factory ApexThemeFocus.fromJson(Map<String, dynamic> json) {
    return ApexThemeFocus(
      type: _parseType(json['type']),
      color: _parseColor(
        json['color'],
        defaultValue: 0xFF7C5CFF,
      ),
      borderWidth: _clampDouble(
        json['borderWidth'],
        min: 0,
        max: 8,
        defaultValue: 2,
      ),
      glowIntensity: _clampDouble(
        json['glow'],
        min: 0,
        max: 1,
        defaultValue: 0.35,
      ),
      cornerRadius: _clampDouble(
        json['cornerRadius'],
        min: 0,
        max: 48,
        defaultValue: 16,
      ),
      scale: _clampDouble(
        json['scale'],
        min: 1,
        max: 1.2,
        defaultValue: 1.03,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.name,
      'color':
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
      'borderWidth': borderWidth,
      'glow': glowIntensity,
      'cornerRadius': cornerRadius,
      'scale': scale,
    };
  }

  ApexThemeFocus copyWith({
    ApexFocusStyleType? type,
    Color? color,
    double? borderWidth,
    double? glowIntensity,
    double? cornerRadius,
    double? scale,
  }) {
    return ApexThemeFocus(
      type: type ?? this.type,
      color: color ?? this.color,
      borderWidth: borderWidth ?? this.borderWidth,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      scale: scale ?? this.scale,
    );
  }

  static ApexFocusStyleType _parseType(dynamic value) {
    switch (value) {
      case 'border':
        return ApexFocusStyleType.border;
      case 'glow':
        return ApexFocusStyleType.glow;
      case 'doubleBorder':
        return ApexFocusStyleType.doubleBorder;
      case 'borderAndGlow':
        return ApexFocusStyleType.borderAndGlow;
      default:
        return ApexFocusStyleType.doubleBorder;
    }
  }

  static double _clampDouble(
    dynamic value, {
    required double min,
    required double max,
    required double defaultValue,
  }) {
    final parsed = value is num ? value.toDouble() : defaultValue;
    return parsed.clamp(min, max).toDouble();
  }

  /// Convertit une couleur #RRGGBB ou #AARRGGBB.
  ///
  /// Une valeur incorrecte utilise la couleur de secours.
  static Color _parseColor(
    dynamic value, {
    required int defaultValue,
  }) {
    if (value is! String) {
      return Color(defaultValue);
    }

    final input = value.trim();
    final pattern = RegExp(
      r'^#(?:[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
    );

    if (!pattern.hasMatch(input)) {
      return Color(defaultValue);
    }

    final hex = input.substring(1);
    final argb = hex.length == 6 ? 'FF$hex' : hex;
    final parsed = int.tryParse(argb, radix: 16);

    return Color(parsed ?? defaultValue);
  }
}
