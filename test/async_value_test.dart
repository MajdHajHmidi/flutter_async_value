import 'package:flutter/material.dart';
import 'package:flutter_async_value/async_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValue', () {
    test('should return correct status for each constructor', () {
      final initial = AsyncValue<int, String>.initial();
      expect(initial.isInitial, true);

      final loading = AsyncValue<int, String>.loading();
      expect(loading.isLoading, true);

      final data = AsyncValue<int, String>.data(data: 42);
      expect(data.isData, true);
      expect(data.data, 42);

      final error = AsyncValue<int, String>.error(error: 'Oops');
      expect(error.isError, true);
      expect(error.error, 'Oops');
    });

    test('maybeWhen calls correct callback', () {
      final value = AsyncValue<int, String>.data(data: 99);

      final result = value.maybeWhen(
        data: (d) => 'Data: $d',
        orElse: () => 'Fallback',
      );

      expect(result, 'Data: 99');
    });
  });

  group('PaginatedAsyncValue', () {
    test('mergeData combines properly', () {
      final value =
          PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);

      final merged =
          value.mergeData([4, 5], combine: (old, next) => [...old, ...next]);

      expect(merged.data, [1, 2, 3, 4, 5]);
      expect(merged.pageState, PageState.none);
    });

    test('copyWithPageState works', () {
      final value = PaginatedAsyncValue<List<int>, String>.data(data: [1]);

      final loadingPage = value.copyWithPageLoading();
      expect(loadingPage.pageState, PageState.loading);

      final errorPage = loadingPage.copyWithPageError('Load failed');
      expect(errorPage.pageState, PageState.error);
    });
  });

  group('AsyncValueBuilder widget tests', () {
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

  group('PaginatedAsyncValueBuilder', () {
    testWidgets('renders builder when pageState is none', (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.data(
        data: [1, 2, 3],
        pageState: PageState.none,
      );

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

    testWidgets(
        'renders loadingPage when pageState is loading and builder provided',
        (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.data(
        data: [1, 2, 3],
        pageState: PageState.loading,
      );

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

    testWidgets('renders builder as fallback when loadingPage not provided',
        (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.data(
        data: [1, 2, 3],
        pageState: PageState.loading,
      );

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

    testWidgets(
        'renders pageError when pageState is error and builder provided',
        (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.data(
        data: [1, 2, 3],
      ).copyWithPageError('Load failed');

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Data default'),
            pageError: (context, data, error) => Text('Error: $error'),
          ),
        ),
      );

      expect(find.text('Error: Load failed'), findsOneWidget);
    });

    testWidgets('renders builder as fallback when pageError not provided',
        (tester) async {
      final value = PaginatedAsyncValue<List<int>, String>.data(
        data: [1, 2, 3],
      ).copyWithPageError('Load failed');

      await tester.pumpWidget(
        MaterialApp(
          home: PaginatedAsyncValueBuilder<List<int>, String>(
            value: value,
            builder: (context, data) => const Text('Default builder'),
          ),
        ),
      );

      expect(find.text('Default builder'), findsOneWidget);
    });

    testWidgets('throws error if value is not in data state', (tester) async {
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
