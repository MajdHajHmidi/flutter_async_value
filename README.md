
# flutter_async_value

A simple and elegant way to handle asynchronous states in Flutter apps. The `AsyncValue<T, E>` class provides a clean and unified interface to represent four common async states: `initial`, `loading`, `data`, and `error`. Combined with the `AsyncValueBuilder<T, E>` widget and `AsyncResult<T, E>` utility, this package simplifies state management and UI rendering for asynchronous operations.

## ✨ Features

- **Unified Async States**: `AsyncValue<T, E>` handles `initial`, `loading`, `data`, and `error` states
- **Minimal Boilerplate**: Reduces repetitive code in async UI rendering
- **Typed Error and Data**: Specify custom types for data and error
- **UI Composition**: `AsyncValueBuilder<T, E>` builds UI based on async state
- **State Transformation**: Methods like `map`, `maybeMap`, and `copyWith` for clean transitions
- **Lightweight**: No dependencies outside Flutter SDK

## 🚀 Installation

Add this to your `pubspec.yaml`:

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

### Create an `AsyncValue<T, E>`

```dart
AsyncValue<String, Exception> value = AsyncValue.initial();

// While loading
value = AsyncValue.loading();

// On success
value = AsyncValue.data("Hello World");

// On error
value = AsyncValue.error(Exception("Something went wrong"));
```

### Use `AsyncValueBuilder`

```dart
AsyncValueBuilder<String, Exception>(
  value: value,
  initial: (_) => const Text('Idle'),
  loading: (_) => const CircularProgressIndicator(),
  data: (_, data) => Text('Result: $data'),
  error: (_, error) => Text('Error: $error'),
)
```

## 📘 API Reference

### `AsyncValue<T, E>`

Represents the four async states.

#### Constructors:

- `AsyncValue.initial()`
- `AsyncValue.loading()`
- `AsyncValue.data(T data)`
- `AsyncValue.error(E error)`

#### Properties and Methods:

- `isInitial`, `isLoading`, `isData`, `isError`
- `copyWith({T? data, E? error})`
- `map({required ..., required ..., ...})`
- `maybeMap({...})`

### `AsyncValueBuilder<T, E>`

Builds widgets based on the current state of `AsyncValue<T, E>`.

```dart
AsyncValueBuilder<T, E>({
  required AsyncValue<T, E> value,
  required WidgetBuilder initial,
  required WidgetBuilder loading,
  required Widget Function(BuildContext, T) data,
  required Widget Function(BuildContext, E) error,
});
```

### `AsyncResult<T, E>`

Represents a simplified result type with only `data` or `error`.

```dart
final result = AsyncResult<String, String>.data("Success");

result.map(
  data: (value) => print(value),
  error: (e) => print("Error: $e"),
);
```

## 🧪 Example

```dart
class MyWidget extends StatelessWidget {
  final AsyncValue<String, Exception> value;

  const MyWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
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
