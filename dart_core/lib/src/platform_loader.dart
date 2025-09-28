import 'dart:ffi';
import 'dart:io';

const String _pluginName = 'app_core';
const String _libName = 'rust_core';

DynamicLibrary loadLibrary() {
  if (Platform.isMacOS) {
    // For macOS apps with statically linked libraries, use process()
    try {
      return DynamicLibrary.process();
    } catch (e) {
      // Fallback to dylib in current directory (for tests)
      return DynamicLibrary.open('lib$_libName.dylib');
    }
  }
  if (Platform.isIOS) {
    // For iOS, also use process() for statically linked libraries
    return DynamicLibrary.process();
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}
