import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reservation/main.dart';

void main() {
  testWidgets('App starts without crash', (WidgetTester tester) async {
    await tester.pumpWidget(const PadelApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
