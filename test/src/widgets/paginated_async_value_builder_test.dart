import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_async_value/flutter_async_value.dart';

void main() {
  group('PaginatedAsyncValueBuilder Widget Tests', () {
    testWidgets('renders builder when pageState is none', (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => Text('Data: ${data.join(',')}'),
          ),
        ),
      );

      expect(find.text('Data: 1,2,3'), findsOneWidget);
    });

    testWidgets('renders loadingPage when in page loading state', (tester) async {
      final base = PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);
      final value = PaginatedAsyncValue<List<int>, String>.loading(previous: base);

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Base'),
            loadingPage: (context, data) => const Text('Loading more...'),
          ),
        ),
      );

      expect(find.text('Loading more...'), findsOneWidget);
    });

    testWidgets('falls back to builder if loadingPage is not provided', (tester) async {
      final base = PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);
      final value = PaginatedAsyncValue<List<int>, String>.loading(previous: base);

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Base fallback'),
          ),
        ),
      );

      expect(find.text('Base fallback'), findsOneWidget);
    });

    testWidgets('renders pageError when provided', (tester) async {
      final base = PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);
      final value = PaginatedAsyncValue<List<int>, String>.error(
        error: 'Load failed',
        previous: base,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Base'),
            pageError: (context, data, error) => Text('Error: $error'),
          ),
        ),
      );

      expect(find.text('Error: Load failed'), findsOneWidget);
    });

    testWidgets('falls back to builder if pageError not provided', (tester) async {
      final base = PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);
      final value = PaginatedAsyncValue<List<int>, String>.error(
        error: 'Load failed',
        previous: base,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Fallback'),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('throws FlutterError when state is unusable for builder', (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.loading();

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Should not render'),
          ),
        ),
      );

      expect(tester.takeException(), isFlutterError);
    });
  });
}
