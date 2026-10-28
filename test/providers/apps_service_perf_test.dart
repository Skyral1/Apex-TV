import 'package:flutter/foundation.dart' show debugPrint;
import 'package:apex_tv/database.dart';
import 'package:apex_tv/models/app.dart';
import 'package:apex_tv/models/category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks.mocks.dart';

void main() {
  test('Performance test for _initDefaultCategories loop vs batch', () async {
    final database = MockFLauncherDatabase();

    final apps = List.generate(500, (i) => App(
      packageName: 'com.test.app$i',
      name: 'Test App $i',
      version: '1.0.$i',
      hidden: false,
    ));

    when(database.nextAppCategoryOrder(any)).thenAnswer((_) => Future.value(0));
    when(database.insertAppsCategories(any)).thenAnswer((_) => Future.value());

    final stopwatch = Stopwatch()..start();

    final tvAppsCategory = Category(id: 1, name: "TV Apps", type: CategoryType.grid, order: 1);

    // Simulate current loop logic for a large list
    for (final app in apps) {
       int index = await database.nextAppCategoryOrder(tvAppsCategory.id) ?? 0;
       await database.insertAppsCategories([
          AppsCategoriesCompanion.insert(
            categoryId: tvAppsCategory.id,
            appPackageName: app.packageName,
            order: index,
          )
       ]);
    }

    stopwatch.stop();
    debugPrint('Baseline logic took: ${stopwatch.elapsedMilliseconds} ms');
    final baselineCalls = verify(database.insertAppsCategories(any)).callCount;
    debugPrint('Calls to insertAppsCategories: $baselineCalls');
    expect(baselineCalls, apps.length);
    verify(database.nextAppCategoryOrder(tvAppsCategory.id)).called(apps.length);

    // Optimized Logic
    clearInteractions(database);
    when(database.nextAppCategoryOrder(any)).thenAnswer((_) => Future.value(0));
    when(database.insertAppsCategories(any)).thenAnswer((_) => Future.value());

    final stopwatchOptimized = Stopwatch()..start();

    int nextOrder = await database.nextAppCategoryOrder(tvAppsCategory.id) ?? 0;
    List<AppsCategoriesCompanion> batch = [];
    for (final app in apps) {
       batch.add(AppsCategoriesCompanion.insert(
            categoryId: tvAppsCategory.id,
            appPackageName: app.packageName,
            order: nextOrder,
       ));
       nextOrder++;
    }
    await database.insertAppsCategories(batch);

    stopwatchOptimized.stop();
    debugPrint('Optimized logic took: ${stopwatchOptimized.elapsedMilliseconds} ms');
    final optimizedCalls = verify(database.insertAppsCategories(any)).callCount;
    debugPrint('Calls to insertAppsCategories: $optimizedCalls');
    expect(optimizedCalls, 1);
    verify(database.nextAppCategoryOrder(tvAppsCategory.id)).called(1);
    expect(batch, hasLength(apps.length));
    for (var i = 0; i < apps.length; i++) {
      expect(batch[i].categoryId.value, tvAppsCategory.id);
      expect(batch[i].appPackageName.value, apps[i].packageName);
      expect(batch[i].order.value, i);
    }
  });
}
