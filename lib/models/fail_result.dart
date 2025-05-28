import 'package:flutter/foundation.dart';

class FailResult {
  FailResult(this.exception, this.stackTrace) {
    debugPrint(exception.runtimeType.toString());
    debugPrint(exception.toString());
    debugPrint(stackTrace.toString());
  }

  dynamic exception;
  StackTrace stackTrace;
}
