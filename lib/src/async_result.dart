part of '../flutter_async_value.dart';

/// Represents the result status of an asynchronous operation.
enum AsyncResultStatus { error, data }

/// A model class to represent an asynchronous result.
///
/// It can be either:
/// - [data] — when the request is successful
/// - [error] — when the request has failed
class AsyncResult<T, E> {
  final AsyncResultStatus _status;
  final T? data;
  final E? error;

  const AsyncResult.data({required this.data})
      : _status = AsyncResultStatus.data,
        error = null;

  const AsyncResult.error({required this.error})
      : _status = AsyncResultStatus.error,
        data = null;

  bool get isData => _status == AsyncResultStatus.data;
  bool get isError => _status == AsyncResultStatus.error;
}
