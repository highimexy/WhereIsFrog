import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:where_is_frog/main.dart';
import 'package:where_is_frog/screens/splash_screen.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    // Consume the splash screen's navigation timer so it doesn't leak past
    // the test's teardown.
    await tester.pump(const Duration(seconds: 3));
  });
}
