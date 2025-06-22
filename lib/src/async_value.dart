part of '../flutter_async_value.dart';

/// Represents the status of an asynchronous operation.
enum AsyncValueStatus { loading, error, data, initial }

/// A model class to represent an asynchronous value.
///
/// It can be either:
/// - [initial] — when the request hasn't started
/// - [loading] — when the request is ongoing
/// - [data] — when the request is successful
/// - [error] — when the request has failed
class AsyncValue<T, E> {
  final AsyncValueStatus status;
  final T? data;
  final E? error;

  const AsyncValue._({
    required this.status,
    this.data,
    this.error,
  });

  const AsyncValue.initial()
      : this._(status: AsyncValueStatus.initial, data: null, error: null);

  const AsyncValue.loading()
      : this._(status: AsyncValueStatus.loading, data: null, error: null);

  const AsyncValue.data({required T data})
      : this._(status: AsyncValueStatus.data, data: data, error: null);

  const AsyncValue.error({required E error})
      : this._(status: AsyncValueStatus.error, data: null, error: error);

  bool get isInitial => status == AsyncValueStatus.initial;
  bool get isLoading => status == AsyncValueStatus.loading;
  bool get isData => status == AsyncValueStatus.data;
  bool get isError => status == AsyncValueStatus.error;

  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? data,
    R Function(E error)? error,
    required R Function() orElse,
  }) {
    switch (status) {
      case AsyncValueStatus.initial:
        return initial?.call() ?? orElse();
      case AsyncValueStatus.loading:
        return loading?.call() ?? orElse();
      case AsyncValueStatus.data:
        return data?.call(this.data as T) ?? orElse();
      case AsyncValueStatus.error:
        return error?.call(this.error as E) ?? orElse();
    }
  }
}
