import 'package:apex_tv/providers/apps_service.dart';
import 'package:apex_tv/providers/launcher_state.dart';
import 'package:apex_tv/widgets/settings/accessibility_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:apex_tv/providers/settings_service.dart';
import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("AccessibilityPage renders correctly when default launcher",
      (tester) async {
    _configureTestDisplay(tester);
    final appsService = MockAppsService();
    final launcherState = LauncherState();
    final settingsService = MockSettingsService();

    when(appsService.isDefaultLauncher()).thenAnswer((_) async => true);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);
    when(settingsService.startOnBoot).thenReturn(false);
    when(settingsService.accentColorHex).thenReturn("7C4DFF");

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppsService>.value(value: appsService),
          ChangeNotifierProvider<LauncherState>.value(value: launcherState),
          ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        ],
        builder: (_, __) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AccessibilityPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Accessibility"), findsOneWidget);
    expect(find.text("Apex TV is the default launcher"), findsOneWidget);
    expect(find.text("Set as default launcher"), findsOneWidget);
  });

  testWidgets("AccessibilityPage renders correctly when not default launcher",
      (tester) async {
    _configureTestDisplay(tester);
    final appsService = MockAppsService();
    final launcherState = LauncherState();
    final settingsService = MockSettingsService();

    when(appsService.isDefaultLauncher()).thenAnswer((_) async => false);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);
    when(settingsService.startOnBoot).thenReturn(false);
    when(settingsService.accentColorHex).thenReturn("7C4DFF");

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppsService>.value(value: appsService),
          ChangeNotifierProvider<LauncherState>.value(value: launcherState),
          ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        ],
        builder: (_, __) => MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AccessibilityPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Accessibility"), findsOneWidget);
    expect(find.text("Apex TV is not the default launcher"), findsOneWidget);
  });
}

/// Configure l'affichage de ce test et restaure ses paramètres à la fin.
void _configureTestDisplay(WidgetTester tester) {
  tester.view.physicalSize = const Size(1280, 720);
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = 0.8;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}
