import 'dart:async';

/// Point d'entrée partagé par les tests Flutter.
///
/// SQLite est fourni par les build hooks de package:sqlite3.
/// Aucun chargement manuel de bibliothèque native n'est nécessaire.
Future<void> testExecutable(
  FutureOr<void> Function() testMain,
) async {
  await testMain();
}
