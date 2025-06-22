import 'package:flutter_async_value/flutter_async_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncValue Unit Tests', () {
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
}
