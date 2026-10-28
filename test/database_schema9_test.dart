import 'package:drift_dev/api/migrations_native.dart';
import 'package:apex_tv/database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated_migrations/schema.dart';
import 'generated_migrations/schema_v8.dart' as v8;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  for (final oldVersion in [1, 2, 3, 4, 5]) {
    test('upgrade from v$oldVersion to v9 preserves associations', () async {
      final schema = await verifier.schemaAt(oldVersion);
      final oldDb = GeneratedHelper().databaseForVersion(
        schema.newConnection().executor,
        oldVersion,
      );

      try {
        // Seule la v1 contient encore la colonne class_name obligatoire.
        if (oldVersion == 1) {
          await oldDb.customStatement(
            'INSERT INTO apps (package_name, name, class_name, version) '
            "VALUES ('com.example.player', 'Player', '.MainActivity', '1.0.0')",
          );
        } else {
          await oldDb.customStatement(
            'INSERT INTO apps (package_name, name, version) '
            "VALUES ('com.example.player', 'Player', '1.0.0')",
          );
        }
        await oldDb.customStatement(
          'INSERT INTO categories (id, name, "order") '
          "VALUES (42, 'Video', 3)",
        );
        await oldDb.customStatement(
          'INSERT INTO apps_categories '
          '(category_id, app_package_name, "order") '
          "VALUES (42, 'com.example.player', 7)",
        );
      } finally {
        await oldDb.close();
      }

      final db = FLauncherDatabase(schema.newConnection());
      try {
        await verifier.migrateAndValidate(db, 9);
        final app = await db.select(db.apps).getSingle();
        final category = await db.select(db.categories).getSingle();
        final association = await db.select(db.appsCategories).getSingle();
        expect(app.packageName, 'com.example.player');
        expect(app.name, 'Player');
        expect(app.version, '1.0.0');
        expect(app.lastLaunchedAt, isNull);
        expect(category.id, 42);
        expect(category.name, 'Video');
        expect(category.order, 3);
        expect(association.categoryId, 42);
        expect(association.appPackageName, 'com.example.player');
        expect(association.order, 7);
      } finally {
        await db.close();
      }
    });
  }

  test('new database matches the version 9 snapshot', () async {
    final db = FLauncherDatabase.inMemory();
    try {
      await verifier.migrateAndValidate(db, 9);
      expect(db.wasCreated, isTrue);
      expect(await db.select(db.apps).get(), isEmpty);
      expect(await db.select(db.categories).get(), isEmpty);
      expect(await db.select(db.appsCategories).get(), isEmpty);
      expect(await db.select(db.launcherSpacers).get(), isEmpty);
    } finally {
      await db.close();
    }
  });

  for (final invalidColumn in ['category_id', 'app_package_name']) {
    test('failed migration preserves v8 data with NULL in $invalidColumn',
        () async {
      final schema = await verifier.schemaAt(8);
      final oldDb = v8.DatabaseAtV8(schema.newConnection().executor);
      try {
        await oldDb.customStatement(
          'INSERT INTO apps (package_name, name, version, hidden) '
          "VALUES ('com.example.player', 'Player', '1.0.0', 0)",
        );
        await oldDb.customStatement(
          'INSERT INTO categories (id, name, "order") '
          "VALUES (42, 'Video', 3)",
        );
        await oldDb.customStatement(
          'INSERT INTO apps_categories '
          '(category_id, app_package_name, "order") VALUES (?, ?, ?)',
          [
            invalidColumn == 'category_id' ? null : 42,
            invalidColumn == 'app_package_name' ? null : 'com.example.player',
            7,
          ],
        );
      } finally {
        await oldDb.close();
      }

      final db = FLauncherDatabase(schema.newConnection());
      try {
        await expectLater(
          db.customSelect('SELECT 1').get(),
          throwsA(isA<StateError>().having(
            (error) => error.message.toString(),
            'message',
            contains('identifiant NULL'),
          )),
        );
      } finally {
        await db.close();
      }

      // Réouvre le même stockage : ni la version ni les données ne changent.
      final unchanged = v8.DatabaseAtV8(schema.newConnection().executor);
      try {
        final version = await unchanged
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.read<int>('user_version'), 8);
        final app = await unchanged
            .customSelect('SELECT * FROM apps')
            .getSingle();
        expect(app.read<String>('package_name'), 'com.example.player');
        expect(app.read<String>('name'), 'Player');
        expect(app.read<String>('version'), '1.0.0');
        final category = await unchanged
            .customSelect('SELECT * FROM categories')
            .getSingle();
        expect(category.read<int>('id'), 42);
        expect(category.read<String>('name'), 'Video');
        expect(category.read<int>('order'), 3);
        final row = await unchanged
            .customSelect('SELECT * FROM apps_categories')
            .getSingle();
        expect(row.data[invalidColumn], isNull);
        expect(row.read<int>('order'), 7);
        if (invalidColumn == 'category_id') {
          expect(row.read<String>('app_package_name'), 'com.example.player');
        } else {
          expect(row.read<int>('category_id'), 42);
        }
      } finally {
        await unchanged.close();
      }
    });
  }
}
