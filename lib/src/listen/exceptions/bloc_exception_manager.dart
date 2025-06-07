import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/src/models/exception_strategy.dart';

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
      debugPrint('Exception strategy used: ${strategy.runtimeType}');
      strategy.handle(context, listener, exception);
    } catch (e) {
      debugPrint('PipenBloc internal exception');
      debugPrint(e.toString());
      onUnknown.call(context);
    }
  }
}
