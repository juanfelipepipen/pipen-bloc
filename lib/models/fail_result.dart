import 'package:flutter/foundation.dart';

class FailResult {
  FailResult(this.exception, this.stackTrace) {
    if (kDebugMode) {
      print(exception.runtimeType);
      print(exception);
      print(stackTrace);
    }
  }

  dynamic exception;
  StackTrace stackTrace;
}
