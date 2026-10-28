/*
 * FLauncher
 * Copyright (C) 2021  Étienne Fesser
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:drift_dev/api/migrations_native.dart';
import 'package:apex_tv/database.dart';
import 'package:apex_tv/models/category.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated_migrations/schema.dart';
import 'generated_migrations/schema_v1.dart' as v1;
import 'generated_migrations/schema_v2.dart' as v2;
import 'generated_migrations/schema_v3.dart' as v3;
import 'generated_migrations/schema_v4.dart' as v4;
import 'generated_migrations/schema_v8.dart' as v8;

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test("upgrade from v1 to v8", () async {
    final schema = await verifier.schemaAt(1);

    final oldDb = v1.DatabaseAtV1(schema.newConnection().executor);
    await oldDb.customStatement(
      "INSERT INTO apps (package_name, name, class_name, version) VALUES ('me.efesser.flauncher', 'FLauncher', '.MainActivity', '0.0.1');",
    );
    await oldDb.customStatement(
      "INSERT INTO categories (id, name, \"order\") VALUES (1, 'Applications', 0);",
    );
    await oldDb.customStatement(
      "INSERT INTO apps_categories (category_id, app_package_name, \"order\") VALUES (1, 'me.efesser.flauncher', 0);",
    );
    await oldDb.close();

    final db = FLauncherDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 8);

    final app = await db.select(db.apps).getSingle();
    final category = await db.select(db.categories).getSingle();
    final appsCategory = await db.select(db.appsCategories).getSingle();
    expect(app.packageName, "me.efesser.flauncher");
    expect(app.name, "FLauncher");
    expect(app.version, "0.0.1");
    expect(app.hidden, false);
    expect(category.id, 1);
    expect(category.name, "Applications");
    expect(category.order, 0);
    expect(category.sort, CategorySort.manual);
    expect(category.type, CategoryType.grid);
    expect(category.columnsCount, 6);
    expect(category.rowHeight, 110);
    expect(appsCategory.appPackageName, "me.efesser.flauncher");
    expect(appsCategory.categoryId, 1);
    expect(appsCategory.order, 0);
    await db.close();
  });

  test("upgrade from v2 to v8", () async {
    final schema = await verifier.schemaAt(2);

    final oldDb = v2.DatabaseAtV2(schema.newConnection().executor);
    await oldDb.customStatement(
      "INSERT INTO apps (package_name, name, version) VALUES ('me.efesser.flauncher', 'FLauncher', '0.0.1');",
    );
    await oldDb.customStatement(
      "INSERT INTO categories (id, name, \"order\") VALUES (1, 'Applications', 0);",
    );
    await oldDb.customStatement(
      "INSERT INTO apps_categories (category_id, app_package_name, \"order\") VALUES (1, 'me.efesser.flauncher', 0);",
    );
    await oldDb.close();

    final db = FLauncherDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 8);

    final app = await db.select(db.apps).getSingle();
    final category = await db.select(db.categories).getSingle();
    final appsCategory = await db.select(db.appsCategories).getSingle();
    expect(app.packageName, "me.efesser.flauncher");
    expect(app.name, "FLauncher");
    expect(app.version, "0.0.1");
    expect(app.hidden, false);
    expect(category.id, 1);
    expect(category.name, "Applications");
    expect(category.order, 0);
    expect(category.sort, CategorySort.manual);
    expect(category.type, CategoryType.grid);
    expect(category.columnsCount, 6);
    expect(category.rowHeight, 110);
    expect(appsCategory.appPackageName, "me.efesser.flauncher");
    expect(appsCategory.categoryId, 1);
    expect(appsCategory.order, 0);
    await db.close();
  });

  test("upgrade from v3 to v8", () async {
    final schema = await verifier.schemaAt(3);

    final oldDb = v3.DatabaseAtV3(schema.newConnection().executor);
    await oldDb.customStatement(
      "INSERT INTO apps (package_name, name, version) VALUES ('me.efesser.flauncher', 'FLauncher', '0.0.1');",
    );
    await oldDb.customStatement(
      "INSERT INTO categories (id, name, \"order\") VALUES (1, 'Applications', 0);",
    );
    await oldDb.customStatement(
      "INSERT INTO apps_categories (category_id, app_package_name, \"order\") VALUES (1, 'me.efesser.flauncher', 0);",
    );
    await oldDb.close();

    final db = FLauncherDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 8);

    final app = await db.select(db.apps).getSingle();
    final category = await db.select(db.categories).getSingle();
    final appsCategory = await db.select(db.appsCategories).getSingle();
    expect(app.packageName, "me.efesser.flauncher");
    expect(app.name, "FLauncher");
    expect(app.version, "0.0.1");
    expect(app.hidden, false);
    expect(category.id, 1);
    expect(category.name, "Applications");
    expect(category.order, 0);
    expect(category.sort, CategorySort.manual);
    expect(category.type, CategoryType.grid);
    expect(category.columnsCount, 6);
    expect(category.rowHeight, 110);
    expect(appsCategory.appPackageName, "me.efesser.flauncher");
    expect(appsCategory.categoryId, 1);
    expect(appsCategory.order, 0);
    await db.close();
  });

  test("upgrade from v4 to v8", () async {
    final schema = await verifier.schemaAt(4);

    final oldDb = v4.DatabaseAtV4(schema.newConnection().executor);
    await oldDb.customStatement(
      "INSERT INTO apps (package_name, name, version) VALUES ('me.efesser.flauncher', 'FLauncher', '0.0.1');",
    );
    await oldDb.customStatement(
      "INSERT INTO categories (id, name, type, \"order\") VALUES (1, 'Applications', 1, 0);",
    );
    await oldDb.customStatement(
      "INSERT INTO apps_categories (category_id, app_package_name, \"order\") VALUES (1, 'me.efesser.flauncher', 0);",
    );
    await oldDb.close();

    final db = FLauncherDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 8);

    final app = await db.select(db.apps).getSingle();
    final category = await db.select(db.categories).getSingle();
    final appsCategory = await db.select(db.appsCategories).getSingle();
    expect(app.packageName, "me.efesser.flauncher");
    expect(app.name, "FLauncher");
    expect(app.version, "0.0.1");
    expect(app.hidden, false);
    expect(category.id, 1);
    expect(category.name, "Applications");
    expect(category.order, 0);
    expect(category.sort, CategorySort.manual);
    expect(category.type, CategoryType.grid);
    expect(category.columnsCount, 6);
    expect(category.rowHeight, 110);
    expect(appsCategory.appPackageName, "me.efesser.flauncher");
    expect(appsCategory.categoryId, 1);
    expect(appsCategory.order, 0);
    await db.close();
  });
  test('upgrade from v8 to v9 preserves associations and constraints',
      () async {
    final schema = await verifier.schemaAt(8);
    final oldDb = v8.DatabaseAtV8(schema.newConnection().executor);

    try {
      await oldDb.customStatement(
        '''
        INSERT INTO apps (package_name, name, version, hidden)
        VALUES ('com.example.player', 'Example Player', '1.0.0', 0)
        ''',
      );

      await oldDb.customStatement(
        '''
        INSERT INTO categories (
          id, name, sort, type, row_height, columns_count, "order"
        )
        VALUES (42, 'Multimedia', 0, 1, 110, 6, 3)
        ''',
      );

      await oldDb.customStatement(
        '''
        INSERT INTO apps_categories (
          category_id, app_package_name, "order"
        )
        VALUES (42, 'com.example.player', 7)
        ''',
      );
    } finally {
      await oldDb.close();
    }

    final db = FLauncherDatabase(schema.newConnection());

    try {
      expect(db.schemaVersion, 9);
      await verifier.migrateAndValidate(db, 9);

      final app = await db.select(db.apps).getSingle();
      final category = await db.select(db.categories).getSingle();
      final association = await db.select(db.appsCategories).getSingle();

      expect(app.packageName, 'com.example.player');
      expect(app.name, 'Example Player');
      expect(app.version, '1.0.0');
      expect(app.hidden, isFalse);
      expect(app.lastLaunchedAt, isNull);

      expect(category.id, 42);
      expect(category.name, 'Multimedia');
      expect(category.order, 3);
      expect(category.sort, CategorySort.manual);
      expect(category.type, CategoryType.grid);
      expect(category.rowHeight, 110);
      expect(category.columnsCount, 6);

      expect(association.categoryId, 42);
      expect(association.appPackageName, 'com.example.player');
      expect(association.order, 7);

      final columns = await db
          .customSelect(
            'PRAGMA table_info(apps_categories)',
          )
          .get();

      for (final columnName in ['category_id', 'app_package_name']) {
        final column = columns.singleWhere(
          (row) => row.read<String>('name') == columnName,
        );

        expect(
          column.read<int>('notnull'),
          1,
          reason: '$columnName doit interdire NULL après migration.',
        );
      }

      expect(
        await db
            .customSelect(
              'PRAGMA foreign_key_check(apps_categories)',
            )
            .get(),
        isEmpty,
      );

      // Vérifie les contraintes au niveau SQL, sans validation Dart.
      await expectLater(
        db.customStatement(
          '''
          INSERT INTO apps_categories (
            category_id, app_package_name, "order"
          )
          VALUES (NULL, 'com.example.player', 8)
          ''',
        ),
        throwsA(isA<Exception>()),
      );

      await expectLater(
        db.customStatement(
          '''
          INSERT INTO apps_categories (
            category_id, app_package_name, "order"
          )
          VALUES (42, NULL, 8)
          ''',
        ),
        throwsA(isA<Exception>()),
      );

      // Suppression de la catégorie : l'association doit disparaître,
      // mais l'application doit rester présente.
      await db.deleteCategory(42);

      expect(await db.select(db.appsCategories).get(), isEmpty);
      expect(await db.select(db.apps).get(), hasLength(1));

      // Recrée une association pour vérifier l'autre cascade.
      await db.customStatement(
        '''
        INSERT INTO categories (
          id, name, sort, type, row_height, columns_count, "order"
        )
        VALUES (43, 'Video', 0, 1, 110, 6, 0)
        ''',
      );

      await db.customStatement(
        '''
        INSERT INTO apps_categories (
          category_id, app_package_name, "order"
        )
        VALUES (43, 'com.example.player', 0)
        ''',
      );

      await db.deleteApps(['com.example.player']);

      expect(await db.select(db.appsCategories).get(), isEmpty);
      expect(await db.select(db.categories).get(), hasLength(1));
    } finally {
      await db.close();
    }
  });

  for (final invalidColumn in ['category_id', 'app_package_name']) {
    test('upgrade from v8 to v9 rejects NULL in $invalidColumn', () async {
      final schema = await verifier.schemaAt(8);
      final oldDb = v8.DatabaseAtV8(schema.newConnection().executor);

      try {
        await oldDb.customStatement(
          '''
          INSERT INTO apps (package_name, name, version, hidden)
          VALUES ('com.example.player', 'Example Player', '1.0.0', 0)
          ''',
        );

        await oldDb.customStatement(
          '''
          INSERT INTO categories (
            id, name, sort, type, row_height, columns_count, "order"
          )
          VALUES (42, 'Multimedia', 0, 1, 110, 6, 0)
          ''',
        );

        // Reproduit une ligne autorisée par l'ancien schéma SQL.
        if (invalidColumn == 'category_id') {
          await oldDb.customStatement(
            '''
            INSERT INTO apps_categories (
              category_id, app_package_name, "order"
            )
            VALUES (NULL, 'com.example.player', 0)
            ''',
          );
        } else {
          await oldDb.customStatement(
            '''
            INSERT INTO apps_categories (
              category_id, app_package_name, "order"
            )
            VALUES (42, NULL, 0)
            ''',
          );
        }
      } finally {
        await oldDb.close();
      }

      final db = FLauncherDatabase(schema.newConnection());

      try {
        // La première requête ouvre la base et déclenche sa migration.
        await expectLater(
          db.customSelect('SELECT 1').get(),
          throwsA(
            isA<StateError>().having(
              (error) => error.message.toString(),
              'message',
              contains('identifiant NULL'),
            ),
          ),
        );
      } finally {
        await db.close();
      }
    });
  }
}
