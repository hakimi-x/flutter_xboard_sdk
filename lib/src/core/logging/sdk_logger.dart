import 'dart:developer' as developer;

// ignore_for_file: avoid_print

class SdkLogger {
  static bool _enabled = false;
  static bool _usePrint = false;
  static String _tag = 'XBoardSDK';

  static void enable({bool enabled = true, String tag = 'XBoardSDK', bool usePrint = false}) {
    _enabled = enabled;
    _tag = tag;
    _usePrint = usePrint;
  }

  static void d(String message, [Object? error, StackTrace? stackTrace]) {
    if (_enabled) {
      if (_usePrint) {
        print('[$_tag] 🐛 $message');
        if (error != null) print('Error: $error');
        if (stackTrace != null) print('StackTrace: $stackTrace');
      } else {
        developer.log(message, name: _tag, error: error, stackTrace: stackTrace, level: 500);
      }
    }
  }

  static void i(String message, [Object? error, StackTrace? stackTrace]) {
    if (_enabled) {
      if (_usePrint) {
        print('[$_tag] ℹ️ $message');
        if (error != null) print('Error: $error');
      } else {
        developer.log(message, name: _tag, error: error, stackTrace: stackTrace, level: 800);
      }
    }
  }

  static void w(String message, [Object? error, StackTrace? stackTrace]) {
    if (_enabled) {
      if (_usePrint) {
        print('[$_tag] ⚠️ $message');
        if (error != null) print('Error: $error');
        if (stackTrace != null) print('StackTrace: $stackTrace');
      } else {
        developer.log(message, name: _tag, error: error, stackTrace: stackTrace, level: 900);
      }
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (_enabled) {
      if (_usePrint) {
        print('[$_tag] ❌ $message');
        if (error != null) print('Error: $error');
        if (stackTrace != null) print('StackTrace: $stackTrace');
      } else {
        developer.log(message, name: _tag, error: error, stackTrace: stackTrace, level: 1000);
      }
    }
  }
}
