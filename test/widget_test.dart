import 'package:ems_app/attendee/widgets/qty_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('Attendee ticket quantity controls', () {
    testWidgets('allows an attendee to increase ticket quantity',
        (WidgetTester tester) async {
      var increaseWasRequested = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QtyButton(
              icon: Icons.add,
              onTap: () => increaseWasRequested = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      expect(increaseWasRequested, isTrue);
    });

    testWidgets('does not change ticket quantity when the control is disabled',
        (WidgetTester tester) async {
      var increaseWasRequested = false;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QtyButton(
              icon: Icons.add,
              onTap: null,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      expect(increaseWasRequested, isFalse);
    });
  });
}
