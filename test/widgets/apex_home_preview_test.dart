import 'package:apex_tv/flauncher_channel.dart';
import 'package:apex_tv/l10n/app_localizations.dart';
import 'package:apex_tv/providers/network_service.dart';
import 'package:apex_tv/providers/tv_inputs_service.dart';
import 'package:apex_tv/widgets/apex_home/apex_home_screen.dart';
import 'package:apex_tv/widgets/settings/settings_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../mocks.mocks.dart';

class _InputsChannel extends FLauncherChannel {
  String? launched;
  @override
  Future<List<Map<dynamic, dynamic>>> getTvInputs() async => [
    {'id': 'tuner', 'label': 'TV tuner', 'type': 0},
    {'id': 'vendor/port1', 'label': 'HDMI 1', 'type': 1007},
    {'id': 'vendor/port1', 'label': 'Duplicate HDMI', 'type': 1007},
    {'id': '', 'label': 'Invalid HDMI', 'type': 1007},
  ];
  @override
  Future<bool> launchTvInput(String inputId) async {
    launched = inputId;
    return true;
  }
}

void main() {
  Future<_InputsChannel> openPreview(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final channel = _InputsChannel();
    final network = MockNetworkService();
    when(network.networkType).thenReturn(NetworkType.wired);
    when(network.cellularNetworkType).thenReturn(CellularNetworkType.unknown);
    when(network.wirelessNetworkSignalLevel).thenReturn(0);
    when(network.vpnActive).thenReturn(false);
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkService>.value(value: network),
        ChangeNotifierProvider<TvInputsService>(create: (_) => TvInputsService(channel)),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: SettingsPanelPage()),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('apexHomePreviewEntry')));
    await tester.pumpAndSettle();
    return channel;
  }

  testWidgets('Preview opens from settings and Escape returns safely', (tester) async {
    await openPreview(tester);
    expect(find.byType(ApexHomeScreen), findsOneWidget);
    final backContext = tester.element(find.byKey(const Key('apexHomeBack')));
    expect(Focus.of(backContext).hasFocus, isTrue);
    expect(find.text('HDMI 1'), findsOneWidget);
    expect(find.text('TV tuner'), findsNothing);
    expect(find.text('Duplicate HDMI'), findsNothing);
    expect(find.text('Invalid HDMI'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(ApexHomeScreen), findsNothing);
    expect(find.byType(SettingsPanelPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Preview launches the exact vendor HDMI id and back button returns', (tester) async {
    final channel = await openPreview(tester);
    await tester.tap(find.text('HDMI 1'));
    await tester.pumpAndSettle();
    expect(channel.launched, 'vendor/port1');
    await tester.tap(find.byKey(const Key('apexHomeBack')));
    await tester.pumpAndSettle();
    expect(find.byType(ApexHomeScreen), findsNothing);
    expect(find.byType(SettingsPanelPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
