part of '../../flutter_async_value.dart';

class PaginatedAsyncValueBuilder<T, E> extends StatelessWidget {
  final PaginatedAsyncValue<T, E> value;

  /// Called when [pageState] is `PageState.none`
  final Widget Function(BuildContext context, T data) builder;

  /// Called when [pageState] is `PageState.loading`
  final Widget Function(BuildContext context, T data)? loadingPage;

  /// Called when [pageState] is `PageState.error`
  final Widget Function(BuildContext context, T data, E error)? pageError;

  const PaginatedAsyncValueBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.loadingPage,
    this.pageError,
  });

  @override
  Widget build(BuildContext context) {
    // Must be in a data state to use this builder
    if (!value.isData || value.data == null) {
      throw FlutterError.fromParts([
        ErrorSummary(
            'PaginatedAsyncValueBuilder requires value.isData to be true.'),
        ErrorDescription(
            'Received status: ${value.status}, pageState: ${value.pageState}'),
      ]);
    }

    final data = value.data as T;

    switch (value.pageState) {
      case PageState.loading:
        return loadingPage?.call(context, data) ?? builder(context, data);
      case PageState.error:
        return pageError?.call(context, data, value.error as E) ??
            builder(context, data);
      case PageState.none:
        return builder(context, data);
    }
  }
}
