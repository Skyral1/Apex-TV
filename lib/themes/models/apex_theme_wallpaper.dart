/// Type de fond d'écran supporté par un thème Apex-TV.
enum ApexWallpaperType {
  solid,
  gradient,
  asset,
  file,
}

/// Description du fond d'écran d'un thème.
///
/// Pour `solid`, `value` contient une couleur hexadécimale.
/// Pour `gradient`, `value` contient deux couleurs séparées par une virgule.
/// Pour `asset` ou `file`, `value` contient un chemin relatif ou local.
class ApexThemeWallpaper {
  const ApexThemeWallpaper({
    required this.type,
    required this.value,
    required this.overlayOpacity,
  });

  final ApexWallpaperType type;
  final String value;
  final double overlayOpacity;

  factory ApexThemeWallpaper.fromJson(Map<String, dynamic> json) {
    return ApexThemeWallpaper(
      type: _parseType(json['type']),
      value: json['value'] is String ? json['value'] as String : '#000000',
      overlayOpacity: _clampOpacity(json['overlayOpacity']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.name,
      'value': value,
      'overlayOpacity': overlayOpacity,
    };
  }

  ApexThemeWallpaper copyWith({
    ApexWallpaperType? type,
    String? value,
    double? overlayOpacity,
  }) {
    return ApexThemeWallpaper(
      type: type ?? this.type,
      value: value ?? this.value,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
    );
  }

  static ApexWallpaperType _parseType(dynamic value) {
    switch (value) {
      case 'solid':
        return ApexWallpaperType.solid;
      case 'gradient':
        return ApexWallpaperType.gradient;
      case 'asset':
        return ApexWallpaperType.asset;
      case 'file':
        return ApexWallpaperType.file;
      default:
        return ApexWallpaperType.solid;
    }
  }

  static double _clampOpacity(dynamic value) {
    final parsed = value is num ? value.toDouble() : 0.0;
    return parsed.clamp(0, 1).toDouble();
  }
}