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
import 'package:apex_tv/providers/settings_service.dart';
import 'package:apex_tv/widgets/settings/applications_panel_page.dart';
import 'package:apex_tv/widgets/settings/interface_settings_page.dart';
import 'package:apex_tv/widgets/settings/general_settings_page.dart';
import 'package:apex_tv/widgets/settings/display_settings_page.dart';
import 'package:apex_tv/widgets/settings/notifications_settings_page.dart';
import 'package:apex_tv/widgets/settings/accessibility_page.dart';
import 'package:apex_tv/widgets/settings/donate_dialog.dart';
import 'package:apex_tv/widgets/settings/flauncher_about_dialog.dart';
import 'package:apex_tv/widgets/settings/settings_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_display.dart';
import '../../mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("'Applications' opens ApplicationsPanelPage", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("Applications"));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("ApplicationsPanelPage")), findsOneWidget);
  });

  testWidgets("'Interface' opens InterfaceSettingsPage", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("Interface"));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("InterfaceSettingsPage")), findsOneWidget);
  });

  testWidgets("'System' opens GeneralSettingsPage", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("System"));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("GeneralSettingsPage")), findsOneWidget);
  });

  testWidgets("'Display & screensaver' opens DisplaySettingsPage", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("Display & Screensaver"));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("DisplaySettingsPage")), findsOneWidget);
  });

  testWidgets("'Notifications' opens NotificationsSettingsPage", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("Notifications"));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("NotificationsSettingsPage")), findsOneWidget);
  });

  testWidgets("'Accessibility' opens AccessibilityPage", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("Accessibility"));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("AccessibilityPage")), findsOneWidget);
  });

  testWidgets("'Android settings' calls AppsService", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("System settings"));
    await tester.pumpAndSettle();
    verify(appsService.openSettings());
  });

  testWidgets("'About LTvLauncher' opens about dialog", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);
    when(settingsService.accentColorHex).thenReturn("7C4DFF");
    PackageInfoPlatform.instance = _MockPackageInfoPlatform();

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("About LTvLauncher"));
    await tester.pumpAndSettle();
    expect(find.byType(LTvLauncherAboutDialog), findsOneWidget);
  });

  testWidgets("'Support & Donate' opens donate dialog", (tester) async {
    configureTestDisplay(tester);
    final settingsService = MockSettingsService();
    final appsService = MockAppsService();
    when(appsService.launcherSections).thenReturn([]);
    when(appsService.applications).thenReturn([]);
    when(settingsService.appHighlightAnimationEnabled).thenReturn(true);
    when(settingsService.accentColorHex).thenReturn("7C4DFF");

    await _pumpWidgetWithProviders(tester, settingsService, appsService);

    await tester.tap(find.text("Support & Donate"));
    await tester.pumpAndSettle();
    expect(find.byType(DonateDialog), findsOneWidget);
  });
}

Future<void> _pumpWidgetWithProviders(
  WidgetTester tester,
  SettingsService settingsService,
  AppsService appsService,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(value: settingsService),
        ChangeNotifierProvider<AppsService>.value(value: appsService),
      ],
      builder: (_, __) => MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          InterfaceSettingsPage.routeName: (_) => Container(key: Key("InterfaceSettingsPage")),
          DisplaySettingsPage.routeName: (_) => Container(key: Key("DisplaySettingsPage")),
          NotificationsSettingsPage.routeName: (_) => Container(key: Key("NotificationsSettingsPage")),
          GeneralSettingsPage.routeName: (_) => Container(key: Key("GeneralSettingsPage")),
          AccessibilityPage.routeName: (_) => Container(key: Key("AccessibilityPage")),
          ApplicationsPanelPage.routeName: (_) => Container(key: Key("ApplicationsPanelPage")),
        },
        home: Material(child: SettingsPanelPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _MockPackageInfoPlatform with MockPlatformInterfaceMixin implements PackageInfoPlatform {
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async => PackageInfoData(
        appName: "LTvLauncher",
        packageName: "com.leanbitlab.ltvL",
        version: "1.0.0",
        buildNumber: "1",
        buildSignature: "",
      );
}
