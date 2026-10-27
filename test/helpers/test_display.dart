import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Configure l'écran de chaque test et restaure les valeurs à sa fin.
///
/// Les paramètres reproduisent les conditions historiques des tests concernés.
void configureTestDisplay(WidgetTester tester) {
  tester.view.physicalSize = const Size(1280, 720);
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = 0.8;

  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}
