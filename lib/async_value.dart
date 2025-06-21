/// A simple utility for handling async states in Flutter.
///
/// This package provides [AsyncValue] and [AsyncValueBuilder] to manage and display
/// loading, success, and error states more easily and consistently.
library;

import 'package:flutter/material.dart';

/// Represents the status of an asynchronous operation.
enum AsyncValueStatus { loading, error, data, initial }

/// Represents the result status of an asynchronous operation.
enum AsyncResultStatus { error, data }

/// Represents the status of an asynchronous pagination operation.
enum PageState { none, loading, error }

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

class PaginatedAsyncValue<T, E> extends AsyncValue<T, E> {
  final PageState pageState;

  const PaginatedAsyncValue._({
    required super.status,
    super.data,
    super.error,
    this.pageState = PageState.none,
  }) : super._();

  factory PaginatedAsyncValue.initial() => PaginatedAsyncValue._(
        status: AsyncValueStatus.initial,
      );

  factory PaginatedAsyncValue.loading() => PaginatedAsyncValue._(
        status: AsyncValueStatus.loading,
      );

  factory PaginatedAsyncValue.data({
    required T data,
    PageState pageState = PageState.none,
  }) =>
      PaginatedAsyncValue._(
        status: AsyncValueStatus.data,
        data: data,
        pageState: pageState,
      );

  factory PaginatedAsyncValue.error({required E error}) =>
      PaginatedAsyncValue._(
        status: AsyncValueStatus.error,
        error: error,
      );

  PaginatedAsyncValue<T, E> copyWithPageState(PageState newPageState) {
    return PaginatedAsyncValue._(
      status: status,
      data: data,
      error: error,
      pageState: newPageState,
    );
  }

  PaginatedAsyncValue<T, E> copyWithPageLoading() =>
      copyWithPageState(PageState.loading);
  PaginatedAsyncValue<T, E> copyWithPageError() =>
      copyWithPageState(PageState.error);
  PaginatedAsyncValue<T, E> clearPageState() =>
      copyWithPageState(PageState.none);

  PaginatedAsyncValue<T, E> mergeData(
    T newData, {
    required T Function(T oldData, T newData) combine,
  }) {
    if (!isData || data == null) {
      // if no existing data, just return new data as is
      return PaginatedAsyncValue.data(data: newData);
    }

    final merged = combine(data as T, newData);

    return PaginatedAsyncValue._(
      status: AsyncValueStatus.data,
      data: merged,
      pageState: PageState.none,
    );
  }

  bool get isLoadingPage => pageState == PageState.loading;
  bool get hasPageError => pageState == PageState.error;

  @override
  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? data,
    R Function(E error)? error,
    R Function(T data)? loadingPage,
    R Function(T data, E error)? pageError,
    required R Function() orElse,
  }) {
    if (isData) {
      if (isLoadingPage && loadingPage != null) {
        return loadingPage(this.data as T);
      } else if (hasPageError && pageError != null) {
        return pageError(this.data as T, this.error as E);
      } else if (data != null) {
        return data(this.data as T);
      }
    }

    return super.maybeWhen(
      initial: initial,
      loading: loading,
      data: data,
      error: error,
      orElse: orElse,
    );
  }
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
  final Widget Function(BuildContext context)? initial;
  final Widget Function(BuildContext context) loading;
  final Widget Function(BuildContext context, T data) data;
  final Widget Function(BuildContext context, E error) error;

  const AsyncValueBuilder({
    super.key,
    required this.value,
    this.initial,
    required this.loading,
    required this.data,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    switch (value.status) {
      case AsyncValueStatus.initial:
        if (initial != null) {
          return initial!(context);
        }
        return loading(context);
      case AsyncValueStatus.loading:
        return loading(context);
      case AsyncValueStatus.data:
        return data(context, value.data as T);
      case AsyncValueStatus.error:
        return error(context, value.error as E);
    }
  }
}
