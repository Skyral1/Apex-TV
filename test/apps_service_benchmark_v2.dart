import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_test/flutter_test.dart';
import 'package:flauncher/database.dart';
import 'package:flauncher/providers/apps_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flauncher/models/app.dart';
import 'package:flauncher/models/category.dart';
import 'package:drift/drift.dart';

import 'mocks.mocks.dart';

void main() {
  late FLauncherDatabase database;
  late MockFLauncherChannel mockChannel;
  late AppsService appsService;

  setUp(() async {
    database = FLauncherDatabase.inMemory();
    mockChannel = MockFLauncherChannel();

    // Minimal mock for getApplications to avoid crash in _refreshState
    when(mockChannel.getApplications()).thenAnswer((_) async => []);

    appsService = AppsService(mockChannel, database);
    // Wait for initialization
    while (!appsService.initialized) {
      await Future.delayed(Duration(milliseconds: 10));
    }
  });

  tearDown(() async {
    await database.close();
  });

  test('Benchmark addToCategory in loop vs addAllToCategory', () async {
    const int numApps = 100;

    // Pre-create apps and categories
    int categoryId1 = await appsService.addCategory("Loop Category", shouldNotifyListeners: false);
    Category category1 = appsService.categories.firstWhere((c) => c.id == categoryId1);

    int categoryId2 = await appsService.addCategory("Batch Category", shouldNotifyListeners: false);
    Category category2 = appsService.categories.firstWhere((c) => c.id == categoryId2);

    List<App> appsToAdd1 = List.generate(numApps, (i) => App(
      packageName: 'com.example.app_loop$i',
      name: 'App $i',
      version: '1.0.0',
      hidden: false,
    ));

    List<App> appsToAdd2 = List.generate(numApps, (i) => App(
      packageName: 'com.example.app_batch$i',
      name: 'App $i',
      version: '1.0.0',
      hidden: false,
    ));

    // Insert apps into DB before categorizing them
    await database.persistApps(appsToAdd1.map((app) => AppsCompanion(
        packageName: Value(app.packageName),
        name: Value(app.name),
        version: Value(app.version),
    )));
    await database.persistApps(appsToAdd2.map((app) => AppsCompanion(
        packageName: Value(app.packageName),
        name: Value(app.name),
        version: Value(app.version),
    )));

    // Baseline: Loop
    final swLoop = Stopwatch()..start();
    for (final app in appsToAdd1) {
      await appsService.addToCategory(app, category1, shouldNotifyListeners: false);
    }
    swLoop.stop();

    // Batch
    final swBatch = Stopwatch()..start();
    await appsService.addAllToCategory(appsToAdd2, category2, shouldNotifyListeners: false);
    swBatch.stop();

    final persisted = await database.getAppsCategories();
    for (final category in [category1, category2]) {
      final entries = persisted
          .where((entry) => entry.categoryId == category.id)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      final expectedApps = category.id == category1.id ? appsToAdd1 : appsToAdd2;
      expect(entries, hasLength(numApps));
      expect(entries.map((entry) => entry.appPackageName),
          orderedEquals(expectedApps.map((app) => app.packageName)));
      expect(entries.map((entry) => entry.order),
          orderedEquals(List.generate(numApps, (i) => i)));
    }

    debugPrint('LOOP: Adding $numApps apps took ${swLoop.elapsedMilliseconds}ms');
    debugPrint('BATCH: Adding $numApps apps took ${swBatch.elapsedMilliseconds}ms');

    if (swBatch.elapsedMilliseconds < swLoop.elapsedMilliseconds) {
        debugPrint('OPTIMIZATION: Batch was ${swLoop.elapsedMilliseconds - swBatch.elapsedMilliseconds}ms faster');
    }
  });
}
