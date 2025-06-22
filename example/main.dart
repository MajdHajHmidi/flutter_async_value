import 'package:flutter/material.dart';
import 'package:flutter_async_value/flutter_async_value.dart';

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
