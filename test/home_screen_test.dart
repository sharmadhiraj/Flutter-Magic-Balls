import 'package:flutter/material.dart';
import 'package:flutter_magic_balls/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("pause button toggles and reset is available", (tester) async {
    await tester.pumpWidget(const MagicBallsApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byTooltip("Pause"), findsOneWidget);
    await tester.tap(find.byTooltip("Pause"));
    await tester.pump();
    expect(find.byTooltip("Resume"), findsOneWidget);

    await tester.tap(find.byTooltip("Reset"));
    await tester.pump();
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
