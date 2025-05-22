import 'package:pipen_bloc/models/exception_strategy.dart';
import 'package:flutter/widgets.dart';

abstract class BlocExceptionManager {
  /// [Getter] Call on unknown exception
  void Function(BuildContext) get onUnknown;

  /// [Getter] List of exceptions strategies
  List<ListenException> get strategies;

  /// [Event] Decode notification
  void decode({
    required dynamic listener,
    required dynamic exception,
    required BuildContext context,
    List<ListenException> strategies = const [],
  }) {
    try {
      final availableStrategies = [...this.strategies, ...strategies];
      final strategy = availableStrategies.firstWhere(
        (strategy) => strategy.callable(listener, exception),
      );
      strategy.handle(context, listener, exception);
    } catch (_) {
      onUnknown.call(context);
    }
  }
}
