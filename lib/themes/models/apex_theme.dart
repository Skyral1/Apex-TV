import 'apex_theme_colors.dart';
import 'apex_theme_focus.dart';
import 'apex_theme_status_bar.dart';
import 'apex_theme_wallpaper.dart';

/// Style visuel des tuiles d'application.
enum ApexCardStyle {
  modern,
  premium,
  classic,
  capsule,
}

/// Thème complet et partageable d'Apex-TV.
///
/// Un thème est purement déclaratif : il ne contient aucun code exécutable.
class ApexTheme {
  const ApexTheme({
    required this.schemaVersion,
    required this.id,
    required this.name,
    required this.author,
    required this.version,
    required this.description,
    required this.cardStyle,
    required this.colors,
    required this.focus,
    required this.wallpaper,
    required this.statusBar,
    required this.tileCornerRadius,
    required this.tileOpacity,
    required this.showAppNames,
    required this.showCategoryTitles,
  });

  static const int currentSchemaVersion = 1;

  final int schemaVersion;
  final String id;
  final String name;
  final String author;
  final String version;
  final String description;
  final ApexCardStyle cardStyle;
  final ApexThemeColors colors;
  final ApexThemeFocus focus;
  final ApexThemeWallpaper wallpaper;
  final ApexThemeStatusBar statusBar;
  final double tileCornerRadius;
  final double tileOpacity;
  final bool showAppNames;
  final bool showCategoryTitles;

  factory ApexTheme.fromJson(Map<String, dynamic> json) {
    final themeJson = json['theme'] is Map<String, dynamic>
        ? json['theme'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ApexTheme(
      schemaVersion: json['schemaVersion'] is int
          ? json['schemaVersion'] as int
          : currentSchemaVersion,
      id: _parseString(json['id'], defaultValue: 'apex.custom'),
      name: _parseString(json['name'], defaultValue: 'Apex Theme'),
      author: _parseString(json['author'], defaultValue: 'Unknown'),
      version: _parseString(json['version'], defaultValue: '1.0.0'),
      description: _parseString(json['description'], defaultValue: ''),
      cardStyle: _parseCardStyle(themeJson['cardStyle']),
      colors: ApexThemeColors.fromJson(
        _readMap(themeJson['colors']),
      ),
      focus: ApexThemeFocus.fromJson(
        _readMap(themeJson['focusStyle']),
      ),
      wallpaper: ApexThemeWallpaper.fromJson(
        _readMap(themeJson['wallpaper']),
      ),
      statusBar: ApexThemeStatusBar.fromJson(
        _readMap(themeJson['statusBar']),
      ),
      tileCornerRadius: _clampDouble(
        themeJson['tileCornerRadius'],
        min: 0,
        max: 48,
        defaultValue: 16,
      ),
      tileOpacity: _clampDouble(
        themeJson['tileOpacity'],
        min: 0.2,
        max: 1,
        defaultValue: 1,
      ),
      showAppNames: _parseBool(
        themeJson['showAppNames'],
        defaultValue: true,
      ),
      showCategoryTitles: _parseBool(
        themeJson['showCategoryTitles'],
        defaultValue: true,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'id': id,
      'name': name,
      'author': author,
      'version': version,
      'description': description,
      'theme': <String, dynamic>{
        'cardStyle': cardStyle.name,
        'colors': colors.toJson(),
        'focusStyle': focus.toJson(),
        'wallpaper': wallpaper.toJson(),
        'statusBar': statusBar.toJson(),
        'tileCornerRadius': tileCornerRadius,
        'tileOpacity': tileOpacity,
        'showAppNames': showAppNames,
        'showCategoryTitles': showCategoryTitles,
      },
    };
  }

  ApexTheme copyWith({
    String? name,
    String? author,
    String? version,
    String? description,
    ApexCardStyle? cardStyle,
    ApexThemeColors? colors,
    ApexThemeFocus? focus,
    ApexThemeWallpaper? wallpaper,
    ApexThemeStatusBar? statusBar,
    double? tileCornerRadius,
    double? tileOpacity,
    bool? showAppNames,
    bool? showCategoryTitles,
  }) {
    return ApexTheme(
      schemaVersion: schemaVersion,
      id: id,
      name: name ?? this.name,
      author: author ?? this.author,
      version: version ?? this.version,
      description: description ?? this.description,
      cardStyle: cardStyle ?? this.cardStyle,
      colors: colors ?? this.colors,
      focus: focus ?? this.focus,
      wallpaper: wallpaper ?? this.wallpaper,
      statusBar: statusBar ?? this.statusBar,
      tileCornerRadius: tileCornerRadius ?? this.tileCornerRadius,
      tileOpacity: tileOpacity ?? this.tileOpacity,
      showAppNames: showAppNames ?? this.showAppNames,
      showCategoryTitles: showCategoryTitles ?? this.showCategoryTitles,
    );
  }

  static ApexCardStyle _parseCardStyle(dynamic value) {
    switch (value) {
      case 'modern':
        return ApexCardStyle.modern;
      case 'premium':
        return ApexCardStyle.premium;
      case 'classic':
        return ApexCardStyle.classic;
      case 'capsule':
        return ApexCardStyle.capsule;
      default:
        return ApexCardStyle.modern;
    }
  }

  static Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    return <String, dynamic>{};
  }

  static String _parseString(dynamic value, {required String defaultValue}) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    return defaultValue;
  }

  static bool _parseBool(dynamic value, {required bool defaultValue}) {
    return value is bool ? value : defaultValue;
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
}