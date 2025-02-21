import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/models/exception_strategy.dart';

class ListenerExceptionStrategy<T> extends ExceptionStrategy {
  ListenerExceptionStrategy({required this.strategy});

  Function(T) strategy;

  @override
  bool callable(exception) => exception is T;

  @override
  void handle(BuildContext context, exception) {
    exception = exception as T;
    strategy.call(exception);
  }
}
