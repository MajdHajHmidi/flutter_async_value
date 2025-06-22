import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValueBuilder Widget Tests', () {
    testWidgets('AsyncValueBuilder displays correct widget', (tester) async {
      final value = AsyncValue<int, String>.data(data: 5);

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncValueBuilder<int, String>(
            value: value,
            loading: (_) => const Text('Loading...'),
            error: (_, e) => Text('Error: $e'),
            data: (_, d) => Text('Data: $d'),
          ),
        ),
      );

      expect(find.text('Data: 5'), findsOneWidget);
    });
  });
}
