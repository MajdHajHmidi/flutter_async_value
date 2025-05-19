/// A simple utility for handling async states in Flutter.
///
/// This package provides [AsyncValue] and [AsyncValueBuilder] to manage and display
/// loading, success, and error states more easily and consistently.
library;

export 'src/async_value_base.dart';

import 'package:flutter/material.dart';

/// Represents the status of an asynchronous operation.
enum AsyncValueStatus { loading, error, data, initial }

/// Represents the result status of an asynchronous operation.
enum AsyncResultStatus { error, data }

/// A model class to represent an asynchronous value.
///
/// It can be either:
/// - [initial] — when the request hasn't started
/// - [loading] — when the request is ongoing
/// - [data] — when the request is successful
/// - [error] — when the request has failed
class AsyncValue<T, E> {
  final AsyncValueStatus _status;
  final T? data;
  final E? error;

  const AsyncValue.initial()
    : _status = AsyncValueStatus.initial,
      data = null,
      error = null;

  const AsyncValue.loading()
    : _status = AsyncValueStatus.loading,
      data = null,
      error = null;

  const AsyncValue.data({required this.data})
    : _status = AsyncValueStatus.data,
      error = null;

  const AsyncValue.error({required this.error})
    : _status = AsyncValueStatus.error,
      data = null;

  bool get isInitial => _status == AsyncValueStatus.initial;
  bool get isLoading => _status == AsyncValueStatus.loading;
  bool get isData => _status == AsyncValueStatus.data;
  bool get isError => _status == AsyncValueStatus.error;
}

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

/// A widget that builds UI based on the [AsyncValue] state.
///
/// Example usage:
/// ```dart
/// AsyncBuilder<int>(
///   value: asyncValue,
///   loading: (context) => CircularProgressIndicator(),
///   data: (context, data) => Text('Data: \$data'),
///   error: (context, error) => Text('Error: \$error'),
/// )
/// ```
class AsyncValueBuilder<T, E> extends StatelessWidget {
  final AsyncValue<T, E> value;
  final Widget Function(BuildContext context) initial;
  final Widget Function(BuildContext context) loading;
  final Widget Function(BuildContext context, T data) data;
  final Widget Function(BuildContext context, E error) error;

  const AsyncValueBuilder({
    super.key,
    required this.value,
    required this.initial,
    required this.loading,
    required this.data,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    switch (value._status) {
      case AsyncValueStatus.initial:
        return initial(context);
      case AsyncValueStatus.loading:
        return loading(context);
      case AsyncValueStatus.data:
        return data(context, value.data as T);
      case AsyncValueStatus.error:
        return error(context, value.error as E);
    }
  }
}
