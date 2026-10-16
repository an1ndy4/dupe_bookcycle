import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookcycle/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BookCycleApp());

    // Verify that our app starts with BookCycle title
    expect(find.text('BookCycle'), findsOneWidget);
  });
}
