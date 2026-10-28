import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Local diagnostic output only. No event is consumed or delayed.
class ApexNavTrace {
  static const enabled = bool.fromEnvironment('APEX_NAV_TRACE');
  static bool _installed = false;
  static int _sequence = 0;

  /// One process-lifetime listener, installed only for opted-in diagnostic builds.
  static void install() {
    if (!enabled || _installed) return;
    _installed = true;
    HardwareKeyboard.instance.addHandler(_key);
    write('trace.enabled');
  }

  static bool _key(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape ||
        event.logicalKey == LogicalKeyboardKey.goBack ||
        event.logicalKey == LogicalKeyboardKey.gameButtonB) {
      write('key ${event.runtimeType} ${event.logicalKey.keyLabel} synthesized=${event.synthesized}',
          context: FocusManager.instance.primaryFocus?.context);
    }
    return false;
  }

  static void write(String event, {BuildContext? context}) {
    if (!enabled) return;
    String state = '';
    if (context != null && context.mounted) {
      final route = ModalRoute.of(context);
      final navigator = Navigator.maybeOf(context);
      state = ' route=${route?.settings.name} current=${route?.isCurrent}'
          ' navigator=${navigator == null ? "none" : identityHashCode(navigator)}';
    }
    debugPrintSynchronously(
      '[APEX_NAV] #${++_sequence} ${DateTime.now().toIso8601String()} $event$state',
    );
  }
}
