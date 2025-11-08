part of '../../flutter_async_value.dart';

/// Builds UI from multiple [AsyncValue]s.
///
/// The UI shows:
/// - `loading` if **any** value is loading or initial
/// - `error` if **any** value has an error
/// - `data` when **all** values have data
///
/// Example:
/// ```dart
/// MultiAsyncValueBuilder(
///   values: [workPackagesValue, typesValue],
///   loading: (context) => const CircularProgressIndicator(),
///   error: (context, error) => Text('Error: $error'),
///   data: (context, dataList) {
///     final workPackages = dataList[0] as PaginatedWorkPackages;
///     final types = dataList[1] as List<WorkPackageType>;
///     return WorkPackagesScreen(workPackages: workPackages, types: types);
///   },
/// )
/// ```
class MultiAsyncValueBuilder<T, E> extends StatelessWidget {
  /// A list of [AsyncValue]s to observe.
  final List<AsyncValue<T, E>> values;

  /// Widget shown when **any** value is initial.
  final Widget Function(BuildContext context)? initial;

  /// Widget shown when **any** value is loading.
  final Widget Function(BuildContext context, List<bool> loadingValues) loading;

  /// Widget shown when **any** value has an error.
  final Widget Function(BuildContext context, List<E?> error) error;

  /// Widget shown when **all** values have data.
  final Widget Function(BuildContext context, List<T> data) data;

  const MultiAsyncValueBuilder({
    super.key,
    required this.values,
    this.initial,
    required this.loading,
    required this.error,
    required this.data,
  });

  bool _isLoading(AsyncValue<T, E> v) {
    // Case 1: Normal AsyncValue
    if (v is! PaginatedAsyncValue) {
      return v.isLoading;
    }

    // Case 2: PaginatedAsyncValue
    final paginated = v as PaginatedAsyncValue<T, E>;
    // We only treat as "loading" if it’s the first load
    return paginated.isFirstLoading;
  }

  List<bool> _getLoadingList(List<AsyncValue<T, E>> values) {
    return [
      for (final value in values) _isLoading(value),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // If any value is initial → show initial (if not null, otherwise → show loading)
    if (values.any((v) => v.isInitial)) {
      return initial?.call(context) ??
          loading(
            context,
            _getLoadingList(values),
          );
    }

    // If any value is loading → show loading
    if (values.any(_isLoading)) {
      return loading(
        context,
        _getLoadingList(values),
      );
    }

    // If any value has an error → return all errors (even null objects)
    if (values.any((v) => v.isError)) {
      return error(context, values.map((v) => v.error).toList());
    }

    // Otherwise, if all values have data → build combined data list
    return data(context, values.map((v) => v.data!).toList());
  }
}
