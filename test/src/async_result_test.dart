import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_async_value/flutter_async_value.dart';

void main() {
  group('AsyncResult Unit Tests', () {
    test('constructs data result correctly', () {
      final result = AsyncResult<int, String>.data(data: 42);

      expect(result.isData, isTrue);
      expect(result.isError, isFalse);
      expect(result.data, 42);
      expect(result.error, isNull);
    });

    test('constructs error result correctly', () {
      final result = AsyncResult<int, String>.error(error: 'Something went wrong');

      expect(result.isError, isTrue);
      expect(result.isData, isFalse);
      expect(result.error, 'Something went wrong');
      expect(result.data, isNull);
    });

    test('only one of data or error is set at a time', () {
      final success = AsyncResult<String, String>.data(data: 'OK');
      final failure = AsyncResult<String, String>.error(error: 'Fail');

      expect(success.data, isNotNull);
      expect(success.error, isNull);
      expect(failure.data, isNull);
      expect(failure.error, isNotNull);
    });
  });
}
