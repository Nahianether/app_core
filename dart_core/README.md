# app_core

Production-ready Flutter FFI plugin with Rust backend.

## Features

- Cross-platform support (Android, iOS, macOS, Linux, Windows)
- Automatic memory management
- Type-safe FFI bindings
- Async operations support
- Built from source (no prebuilt binaries)

## Usage

```dart
import 'package:app_core/app_core.dart';

void main() {
  initAppCore();

  final result = AppCore.sum(10, 20);
  print('Sum: $result');

  final greeting = AppCore.helloWorld();
  print(greeting);
}
```

## License

MIT