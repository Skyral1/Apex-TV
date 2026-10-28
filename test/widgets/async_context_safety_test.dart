import 'dart:async';

import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:apex_tv/providers/apps_service.dart';
import 'package:apex_tv/providers/settings_service.dart';
import 'package:apex_tv/providers/wallpaper_service.dart';
import 'package:apex_tv/widgets/add_to_category_dialog.dart';
import 'package:apex_tv/widgets/application_info_panel.dart';
import 'package:apex_tv/widgets/settings/app_details_page.dart';
import 'package:apex_tv/widgets/settings/wallpaper_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../helpers/test_display.dart';
import '../mocks.dart';
import '../mocks.mocks.dart';

void main() {
  for (final action in ['Open', 'Uninstall']) {
    testWidgets('AppDetailsPage ignores completed $action after disposal',
        (tester) async {
      final apps = MockAppsService();
      final app = fakeApp();
      final pending = Completer<void>();
      when(apps.getAppIcon(any)).thenAnswer((_) async => kTransparentImage);
      when(apps.isAppInFavorites(any)).thenReturn(false);
      if (action == 'Open') {
        when(apps.launchApp(app)).thenAnswer((_) => pending.future);
      } else {
        when(apps.uninstallApp(app)).thenAnswer((_) => pending.future);
      }

      await _pump(tester, AppDetailsPage(application: app), apps: apps);
      await _startAction(tester, action);
      if (action == 'Open') {
        verify(apps.launchApp(app)).called(1);
      } else {
        verify(apps.uninstallApp(app)).called(1);
      }
      await tester.pumpWidget(const SizedBox.shrink());
      pending.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final action in [
    'Open',
    'Add to Fav',
    'Hide',
    'Remove from Test category',
    'Uninstall',
  ]) {
    testWidgets('ApplicationInfoPanel ignores completed $action after disposal',
        (tester) async {
      final apps = MockAppsService();
      final app = fakeApp();
      final category = fakeCategory(name: 'Test category');
      final pending = Completer<void>();
      when(apps.hasCustomBanner(any)).thenAnswer((_) async => false);
      when(apps.isAppInFavorites(any)).thenReturn(false);
      switch (action) {
        case 'Open':
          when(apps.launchApp(app)).thenAnswer((_) => pending.future);
        case 'Add to Fav':
          when(apps.toggleFavorite(app)).thenAnswer((_) => pending.future);
        case 'Hide':
          when(apps.hideApplication(app)).thenAnswer((_) => pending.future);
        case 'Remove from Test category':
          when(apps.removeFromCategory(app, category))
              .thenAnswer((_) => pending.future);
        case 'Uninstall':
          when(apps.uninstallApp(app)).thenAnswer((_) => pending.future);
      }

      await _pump(
        tester,
        ApplicationInfoPanel(category: category, application: app),
        apps: apps,
      );
      await _startAction(tester, action);
      switch (action) {
        case 'Open':
          verify(apps.launchApp(app)).called(1);
        case 'Add to Fav':
          verify(apps.toggleFavorite(app)).called(1);
        case 'Hide':
          verify(apps.hideApplication(app)).called(1);
        case 'Remove from Test category':
          verify(apps.removeFromCategory(app, category)).called(1);
        case 'Uninstall':
          verify(apps.uninstallApp(app)).called(1);
      }
      await tester.pumpWidget(const SizedBox.shrink());
      pending.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('AddToCategoryDialog ignores completion after disposal',
      (tester) async {
    final apps = MockAppsService();
    final app = fakeApp();
    final category = fakeCategory(name: 'Test category');
    final pending = Completer<void>();
    when(apps.categories).thenReturn([category]);
    when(apps.addToCategory(app, category)).thenAnswer((_) => pending.future);

    await _pump(tester, AddToCategoryDialog(app), apps: apps);
    await _startAction(tester, 'Test category');
    verify(apps.addToCategory(app, category)).called(1);
    await tester.pumpWidget(const SizedBox.shrink());
    pending.complete();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('WallpaperPanelPage ignores picker failure after disposal',
      (tester) async {
    final wallpaper = MockWallpaperService();
    final settings = MockSettingsService();
    final pending = Completer<void>();
    when(settings.timeBasedWallpaperEnabled).thenReturn(false);
    when(wallpaper.pickWallpaper()).thenAnswer((_) => pending.future);

    await _pump(
      tester,
      const WallpaperPanelPage(),
      wallpaper: wallpaper,
      settings: settings,
    );
    await _startAction(tester, 'Picture');
    verify(wallpaper.pickWallpaper()).called(1);
    await tester.pumpWidget(const SizedBox.shrink());
    pending.completeError(NoFileExplorerException());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

Future<void> _startAction(WidgetTester tester, String label) async {
  final finder = find.text(label);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  AppsService? apps,
  SettingsService? settings,
  WallpaperService? wallpaper,
}) async {
  configureTestDisplay(tester);
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        if (apps != null) ChangeNotifierProvider<AppsService>.value(value: apps),
        if (settings != null)
          ChangeNotifierProvider<SettingsService>.value(value: settings),
        if (wallpaper != null)
          ChangeNotifierProvider<WallpaperService>.value(value: wallpaper),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
