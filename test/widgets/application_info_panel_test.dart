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

import 'package:apex_tv/providers/apps_service.dart';
import 'package:apex_tv/models/category.dart';
import 'package:apex_tv/models/app.dart';
import 'package:apex_tv/widgets/application_info_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks.dart';
import '../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("'Open' calls launchApp on AppsService", (tester) async {
    final appsService = MockAppsService();
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
    );
    when(appsService.applications).thenReturn([app]);
    await _pumpWidgetWithProviders(tester, appsService, null, app);

    final finder = find.text("Open");
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
    verify(appsService.launchApp(app));
  });

  testWidgets("'Hide' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
    );
    category.applications.add(app);
    when(appsService.launcherSections).thenReturn([category]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    final finder = find.text("Hide");
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
    verify(appsService.hideApplication(app));
  });

  testWidgets("'Remove from...' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
    );
    category.applications.add(app);
    when(appsService.launcherSections).thenReturn([category]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    final finder = find.text("Remove from Category 1");
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
    verify(appsService.removeFromCategory(app, category));
  });

  testWidgets("'App info' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
    );
    category.applications.add(app);
    when(appsService.launcherSections).thenReturn([category]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    final finder = find.text("Application info");
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
    verify(appsService.openAppInfo(app));
  });

  testWidgets("'Uninstall' calls AppsService", (tester) async {
    final appsService = MockAppsService();
    final category = fakeCategory(name: "Category 1", order: 0);
    final app = fakeApp(
      packageName: "me.efesser.flauncher",
      name: "FLauncher",
      version: "1.0.0",
    );
    category.applications.add(app);
    when(appsService.launcherSections).thenReturn([category]);
    when(appsService.applications).thenReturn([]);
    await _pumpWidgetWithProviders(tester, appsService, category, app);

    final finder = find.text("Uninstall");
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
    verify(appsService.uninstallApp(app));
  });
}

Future<void> _pumpWidgetWithProviders(
  WidgetTester tester,
  AppsService appsService,
  Category? category,
  App application,
) async {
  // Conserve les conditions d'affichage historiques de ces tests.
  tester.view.physicalSize = const Size(1280, 720);
  tester.view.devicePixelRatio = 1.0;

  // La police Ahem utilisée dans les tests est plus large que Roboto.
  tester.platformDispatcher.textScaleFactorTestValue = 0.8;

  // Restaure les paramètres après chaque test, même en cas d'échec.
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  when(
    appsService.isAppInFavorites(application),
  ).thenReturn(false);

  when(
    appsService.hasCustomBanner(application.packageName),
  ).thenAnswer((_) async => false);

  when(
    appsService.getAppIcon(application.packageName),
  ).thenAnswer((_) async => Uint8List(0));

  when(
    appsService.getAppBanner(application.packageName),
  ).thenAnswer((_) async => Uint8List(0));

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppsService>.value(
          value: appsService,
        ),
      ],
      builder: (_, __) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ApplicationInfoPanel(
          category: category,
          application: application,
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
