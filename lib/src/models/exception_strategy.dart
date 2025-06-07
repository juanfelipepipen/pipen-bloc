import 'package:flutter/widgets.dart';

typedef ListenExceptionIsCallable = bool Function(dynamic instance, dynamic exception);
typedef ListenExceptionHandler =
    Function(BuildContext context, dynamic listener, dynamic exception);

abstract class ListenException {
  /// Check if exceptions has strategy
  bool callable(dynamic instance, dynamic exception);

  /// Prepare exception strategy
  void handle(BuildContext context, dynamic listener, dynamic exception);

  static SimpleExceptionStrategy seed({
    required ListenExceptionIsCallable callable,
    required ListenExceptionHandler handle,
  }) => SimpleExceptionStrategy(callable: callable, handle: handle);
}

class SimpleExceptionStrategy extends ListenException {
  SimpleExceptionStrategy({
    required ListenExceptionIsCallable callable,
    required ListenExceptionHandler handle,
  }) : _callable = callable,
       _handle = handle;

  final ListenExceptionIsCallable _callable;
  final ListenExceptionHandler _handle;

  @override
  bool callable(instance, exception) => _callable(instance, exception);

  @override
  void handle(BuildContext context, listener, exception) => _handle(context, listener, exception);
}
