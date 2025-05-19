
# flutter_async_value

A simple and elegant way to handle asynchronous states in Flutter apps. The `AsyncValue<T>` class provides a clean and unified interface to represent the four common async states: `initial`, `loading`, `data`, and `error`. Combined with the `AsyncBuilder<T>` widget, it simplifies state management and UI rendering for async operations.

## ✨ Features

- **Unified Async States**: Handle async states declaratively (`initial`, `loading`, `data`, `error`)
- **Minimal Boilerplate**: Reduce repetitive state-checking code
- **Composable Widgets**: `AsyncBuilder<T>` to easily build different UI per state
- **Flexible State Mapping**: Easily transform or update state using methods like `map`, `maybeMap`, and `copyWith`

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_async_value:
    git:
      url: https://github.com/your-username/flutter_async_value.git
```

Then run:

```bash
flutter pub get
```

## 🧩 Usage

### Create an `AsyncValue`

```dart
AsyncValue<String> value = AsyncValue.initial();

// When loading
value = AsyncValue.loading();

// When data is available
value = AsyncValue.data('Hello');

// When there's an error
value = AsyncValue.error(Exception('Something went wrong'));
```

### Update or Transform State

```dart
value = value.copyWith(data: 'Updated'); // only updates data if in data state

value.map(
  initial: (_) => print('Initial'),
  loading: (_) => print('Loading...'),
  data: (data) => print('Data: ${data.data}'),
  error: (error) => print('Error: ${error.error}'),
);
```

### Use `AsyncBuilder` in Widgets

```dart
AsyncBuilder<String>(
  value: value,
  initial: (context) => const Text('Start'),
  loading: (context) => const CircularProgressIndicator(),
  data: (context, data) => Text('Result: $data'),
  error: (context, error) => Text('Oops: $error'),
)
```

## 📘 API Reference

### `AsyncValue<T>`

Represents one of the four async states.

- `AsyncValue.initial()`
- `AsyncValue.loading()`
- `AsyncValue.data(T data)`
- `AsyncValue.error(Object error)`

#### Methods

- `copyWith({T? data, Object? error})`
- `map({...})` – exhaustive pattern matching
- `maybeMap({...})` – optional pattern matching with fallback
- `isInitial`, `isLoading`, `isData`, `isError` – boolean flags

### `AsyncBuilder<T>`

Widget that builds UI based on the current `AsyncValue<T>`.

```dart
AsyncBuilder<T>({
  required AsyncValue<T> value,
  required WidgetBuilder initial,
  required WidgetBuilder loading,
  required Widget Function(BuildContext, T) data,
  required Widget Function(BuildContext, Object) error,
});
```

## 🧪 Example

```dart
class MyWidget extends StatelessWidget {
  final AsyncValue<String> value;

  const MyWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<String>(
      value: value,
      initial: (_) => ElevatedButton(
        onPressed: () => print('Fetch data'),
        child: const Text('Start'),
      ),
      loading: (_) => const CircularProgressIndicator(),
      data: (_, data) => Text('Fetched: $data'),
      error: (_, error) => Text('Error: $error'),
    );
  }
}
```

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🙌 Contributing

Pull requests and issues are welcome! Feel free to suggest improvements or features.
