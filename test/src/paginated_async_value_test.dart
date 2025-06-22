import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_async_value/flutter_async_value.dart';

void main() {
  group('PaginatedAsyncValue Unit Tests', () {
    test('data merges correctly when previous data exists', () {
      final previous =
          PaginatedAsyncValue<List<int>, String>.data(data: [1, 2, 3]);

      final updated = PaginatedAsyncValue<List<int>, String>.data(
        data: [4, 5],
        previous: previous,
        combine: (old, next) => [...old, ...next],
      );

      expect(updated.data, [1, 2, 3, 4, 5]);
      expect(updated.pageState, PageState.none);
    });

    test('data replaces when previous is not provided', () {
      final updated = PaginatedAsyncValue<List<int>, String>.data(data: [1, 2]);

      expect(updated.data, [1, 2]);
      expect(updated.pageState, PageState.none);
    });

    test('throws if previous is provided but combine is missing', () {
      final previous =
          PaginatedAsyncValue<List<int>, String>.data(data: [1, 2]);

      expect(
        () => PaginatedAsyncValue<List<int>, String>.data(
          data: [3, 4],
          previous: previous,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('loading without previous sets top-level loading state', () {
      final loading = PaginatedAsyncValue<List<int>, String>.loading();

      expect(loading.status, AsyncValueStatus.loading);
      expect(loading.data, isNull);
    });

    test('loading with previous sets page loading', () {
      final previous = PaginatedAsyncValue<List<int>, String>.data(data: [1]);
      final loading =
          PaginatedAsyncValue<List<int>, String>.loading(previous: previous);

      expect(loading.status, AsyncValueStatus.data);
      expect(loading.data, [1]);
      expect(loading.pageState, PageState.loading);
    });

    test('error without previous sets top-level error state', () {
      final error = PaginatedAsyncValue<List<int>, String>.error(error: 'Oops');

      expect(error.status, AsyncValueStatus.error);
      expect(error.error, 'Oops');
      expect(error.data, isNull);
      expect(error.pageState, PageState.none);
    });

    test('error with previous sets page error', () {
      final previous = PaginatedAsyncValue<List<int>, String>.data(data: [1]);
      final errored = PaginatedAsyncValue<List<int>, String>.error(
        error: 'Failed',
        previous: previous,
      );

      expect(errored.status, AsyncValueStatus.data);
      expect(errored.data, [1]);
      expect(errored.pageState, PageState.error);
      expect(errored.error, 'Failed');
    });
  });
}
