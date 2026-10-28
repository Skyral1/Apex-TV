import 'package:apex_tv/widgets/settings/applications_panel_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MoveFocusToTabAction invokes its callback exactly once', () {
    var focusRequests = 0;
    final action = MoveFocusToTabAction(() {
      focusRequests++;
    });

    final result = action.invoke(const MoveFocusToTabIntent());

    expect(focusRequests, 1);
    expect(result, isNull);
  });

  test('ChangeTabAction forwards each direction exactly once', () {
    final directions = <int>[];
    final action = ChangeTabAction(directions.add);

    expect(action.invoke(const ChangeTabIntent(-1)), isNull);
    expect(action.invoke(const ChangeTabIntent(1)), isNull);

    expect(directions, orderedEquals([-1, 1]));
  });
}
