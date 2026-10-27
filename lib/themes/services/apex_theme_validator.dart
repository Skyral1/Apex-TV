import '../models/apex_theme.dart';

/// Résultat de validation d'un fichier `.apextheme`.
class ApexThemeValidationResult {
  const ApexThemeValidationResult({
    required this.isValid,
    this.errors = const <String>[],
  });

  final bool isValid;
  final List<String> errors;
}

/// Valide la structure et les valeurs d'un thème avant import.
class ApexThemeValidator {
  const ApexThemeValidator();

  static const int maxSchemaVersion = ApexTheme.currentSchemaVersion;
  static const int maxNameLength = 80;
  static const int maxAuthorLength = 80;
  static const int maxDescriptionLength = 500;

  ApexThemeValidationResult validateJson(Map<String, dynamic> json) {
    final errors = <String>[];

    final schemaVersion = json['schemaVersion'];
    if (schemaVersion is! int) {
      errors.add('Le champ "schemaVersion" doit être un entier.');
    } else if (schemaVersion < 1 || schemaVersion > maxSchemaVersion) {
      errors.add(
        'Version de schéma non supportée : $schemaVersion. '
        'Version maximale supportée : $maxSchemaVersion.',
      );
    }

    _validateRequiredText(
      json,
      key: 'id',
      maxLength: 120,
      errors: errors,
      label: 'identifiant',
    );

    _validateRequiredText(
      json,
      key: 'name',
      maxLength: maxNameLength,
      errors: errors,
      label: 'nom',
    );

    _validateOptionalText(
      json,
      key: 'author',
      maxLength: maxAuthorLength,
      errors: errors,
      label: 'auteur',
    );

    _validateOptionalText(
      json,
      key: 'description',
      maxLength: maxDescriptionLength,
      errors: errors,
      label: 'description',
    );

    final theme = json['theme'];
    if (theme is! Map<String, dynamic>) {
      errors.add('Le champ "theme" doit être un objet JSON.');
      return ApexThemeValidationResult(
        isValid: errors.isEmpty,
        errors: errors,
      );
    }

    final allowedCardStyles = <String>{
      'modern',
      'premium',
      'classic',
      'capsule',
    };

    final cardStyle = theme['cardStyle'];
    if (cardStyle is! String || !allowedCardStyles.contains(cardStyle)) {
      errors.add(
        'Le champ "theme.cardStyle" doit être l\'un des styles suivants : '
        '${allowedCardStyles.join(', ')}.',
      );
    }

    _validateColorField(
      theme,
      path: 'theme.colors.accent',
      errors: errors,
    );

    _validateColorField(
      theme,
      path: 'theme.colors.background',
      errors: errors,
    );

    final focus = theme['focusStyle'];
    if (focus is Map<String, dynamic>) {
      final glow = focus['glow'];
      if (glow is num && (glow < 0 || glow > 1)) {
        errors.add('Le champ "theme.focusStyle.glow" doit être entre 0 et 1.');
      }

      final scale = focus['scale'];
      if (scale is num && (scale < 1 || scale > 1.2)) {
        errors.add(
          'Le champ "theme.focusStyle.scale" doit être entre 1.0 et 1.2.',
        );
      }
    }

    final wallpaper = theme['wallpaper'];
    if (wallpaper is Map<String, dynamic>) {
      final type = wallpaper['type'];
      final allowedWallpaperTypes = <String>{
        'solid',
        'gradient',
        'asset',
        'file',
      };

      if (type is! String || !allowedWallpaperTypes.contains(type)) {
        errors.add(
          'Le champ "theme.wallpaper.type" doit être l\'un des types suivants : '
          '${allowedWallpaperTypes.join(', ')}.',
        );
      }

      final overlay = wallpaper['overlayOpacity'];
      if (overlay is num && (overlay < 0 || overlay > 1)) {
        errors.add(
          'Le champ "theme.wallpaper.overlayOpacity" doit être entre 0 et 1.',
        );
      }
    }

    return ApexThemeValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  void _validateRequiredText(
    Map<String, dynamic> json, {
    required String key,
    required int maxLength,
    required List<String> errors,
    required String label,
  }) {
    final value = json[key];

    if (value is! String || value.trim().isEmpty) {
      errors.add('Le champ "$key" est obligatoire.');
      return;
    }

    if (value.trim().length > maxLength) {
      errors.add('Le $label dépasse $maxLength caractères.');
    }
  }

  void _validateOptionalText(
    Map<String, dynamic> json, {
    required String key,
    required int maxLength,
    required List<String> errors,
    required String label,
  }) {
    final value = json[key];

    if (value == null) {
      return;
    }

    if (value is! String) {
      errors.add('Le champ "$key" doit être une chaîne de caractères.');
      return;
    }

    if (value.length > maxLength) {
      errors.add('Le $label dépasse $maxLength caractères.');
    }
  }

  void _validateColorField(
    Map<String, dynamic> theme, {
    required String path,
    required List<String> errors,
  }) {
    final parts = path.split('.');
    final colors = theme['colors'];

    if (colors is! Map<String, dynamic>) {
      errors.add('Le champ "theme.colors" doit être un objet JSON.');
      return;
    }

    final value = colors[parts.last];

    if (value is! String) {
      errors.add('Le champ "$path" doit être une couleur hexadécimale.');
      return;
    }

    final normalized = value.replaceFirst('#', '');

    if (normalized.length != 6 && normalized.length != 8) {
      errors.add(
        'Le champ "$path" doit utiliser le format #RRGGBB ou #AARRGGBB.',
      );
    }
  }
}