import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/models/exception_strategy.dart';

typedef ListenerExceptionStrategiesList = List<ListenerExceptionStrategy>;

class ListenerExceptionStrategy<T> extends ExceptionStrategy {
  ListenerExceptionStrategy({required this.strategy});

  Function(T) strategy;

  @override
  bool callable(instance, exception) => exception is T;

  @override
  void handle(BuildContext context, instance, exception) {
    exception = exception as T;
    strategy.call(exception);
  }
}
