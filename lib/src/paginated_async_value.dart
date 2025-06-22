part of '../flutter_async_value.dart';

/// Represents the status of an asynchronous pagination operation.
enum PageState { none, loading, error }

class PaginatedAsyncValue<T, E> extends AsyncValue<T, E> {
  final PageState pageState;

  const PaginatedAsyncValue._({
    required super.status,
    super.data,
    super.error,
    this.pageState = PageState.none,
  }) : super._();

  factory PaginatedAsyncValue.initial() => const PaginatedAsyncValue._(
        status: AsyncValueStatus.initial,
      );

  /// Initializes a PaginatedAsyncValue, where two cases are possible:
  /// 1. There's already data, therefore data is restored, and the page state
  /// is set to `loading`
  /// 2. There's no data, so the page state is `none`, and the status is `loading`
  factory PaginatedAsyncValue.loading({PaginatedAsyncValue<T, E>? previous}) {
    final hasData = previous?.data != null;
    return PaginatedAsyncValue._(
      status: hasData ? AsyncValueStatus.data : AsyncValueStatus.loading,
      data: previous?.data,
      pageState: hasData ? PageState.loading : PageState.none,
    );
  }

  /// Initializes a PaginatedAsyncValue, where two cases are possible:
  /// 1. There's already data, therefore new data is merged with the old one
  /// 2. There's no data, therefore new fresh object is created
  factory PaginatedAsyncValue.data({
    required T data,
    PaginatedAsyncValue<T, E>? previous,
    T Function(T oldData, T newData)? combine,
  }) {
    if (previous?.data != null && combine == null) {
      throw Exception(
          'Providing the previous data makes it mandatory to provide a way to combine old data and new data');
    }

    final hasData = previous?.data != null;
    final mergedData = hasData ? combine!(previous!.data as T, data) : data;

    return PaginatedAsyncValue._(
      status: AsyncValueStatus.data,
      data: mergedData,
      pageState: PageState.none,
    );
  }

  /// Initializes a PaginatedAsyncValue, where two cases are possible:
  /// 1. There's already data, therefore new data is recovered and the error
  /// provided in the constructor will be assigned to the `page error`
  /// 2. There's no data, therefore new fresh object is created with an error
  factory PaginatedAsyncValue.error({
    required E error,
    PaginatedAsyncValue<T, E>? previous,
  }) {
    final hasData = previous?.data != null;
    return PaginatedAsyncValue._(
      status: hasData ? AsyncValueStatus.data : AsyncValueStatus.error,
      data: previous?.data,
      error: error,
      pageState: hasData ? PageState.error : PageState.none,
    );
  }

  /// True when loading the first page (no previous data)
  bool get isFirstLoading => super.isLoading && pageState == PageState.none;

  /// True when loading additional page
  bool get isLoadingPage => super.isData && pageState == PageState.loading;

  /// True for any loading (either first page or next page)
  @override
  bool get isLoading => isFirstLoading || isLoadingPage;

  /// True when additional page failed to load
  bool get hasPageError => super.isData && pageState == PageState.error;

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
