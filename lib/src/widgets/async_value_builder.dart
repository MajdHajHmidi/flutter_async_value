part of '../../flutter_async_value.dart';

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
