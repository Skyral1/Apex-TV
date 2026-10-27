import 'dart:convert';

import '../models/apex_theme.dart';
import 'apex_theme_validator.dart';

/// Encode et décode les fichiers `.apextheme`.
///
/// Le format est du JSON UTF-8. Le codec ne télécharge rien, n'exécute rien
/// et n'accède pas au réseau : il travaille uniquement sur une chaîne ou une
/// carte JSON fournie par l'application.
class ApexThemeCodec {
  const ApexThemeCodec({
    this.validator = const ApexThemeValidator(),
  });

  final ApexThemeValidator validator;

  /// Décode le contenu texte d'un fichier `.apextheme`.
  ///
  /// Lance une [ApexThemeCodecException] si le JSON est invalide ou si la
  /// validation échoue.
  ApexTheme decode(String rawContent) {
    final dynamic decoded;

    try {
      decoded = jsonDecode(rawContent);
    } on FormatException catch (error) {
      throw ApexThemeCodecException(
        'Le fichier n\'est pas un JSON valide : ${error.message}',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const ApexThemeCodecException(
        'La racine du fichier .apextheme doit être un objet JSON.',
      );
    }

    final validation = validator.validateJson(decoded);

    if (!validation.isValid) {
      throw ApexThemeCodecException(
        'Thème invalide :\n- ${validation.errors.join('\n- ')}',
      );
    }

    return ApexTheme.fromJson(decoded);
  }

  /// Encode un thème vers le contenu texte d'un fichier `.apextheme`.
  String encode(ApexTheme theme) {
    final validation = validator.validateJson(theme.toJson());

    if (!validation.isValid) {
      throw ApexThemeCodecException(
        'Impossible d\'exporter un thème invalide :\n'
        '- ${validation.errors.join('\n- ')}',
      );
    }

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(theme.toJson());
  }

  /// Convertit un thème en octets UTF-8, prêt à être écrit dans un fichier.
  List<int> encodeToBytes(ApexTheme theme) {
    return utf8.encode(encode(theme));
  }
}

/// Erreur levée lors de l'encodage ou du décodage d'un thème.
class ApexThemeCodecException implements Exception {
  const ApexThemeCodecException(this.message);

  final String message;

  @override
  String toString() => 'ApexThemeCodecException: $message';
}