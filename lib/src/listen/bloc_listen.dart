import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/src/abstract/bloc_listen_exceptions.dart';
import 'package:pipen_bloc/src/abstract/bloc_listen_exceptions_ignore.dart';
import 'package:pipen_bloc/src/abstract/fail_state.dart';
import 'package:pipen_bloc/src/listen/exceptions/bloc_exception_manager.dart';
import 'package:pipen_bloc/src/models/exception_strategy.dart';
import 'package:pipen_bloc/src/models/fail_result.dart';

typedef Listen<T> = ({BuildContext context, T state});

abstract class BlocListen<T> {
  /// Execute listen actions
  void handle({required Listen<T> listen}) {
    /// Handle listen action on state change
    _listen = listen;
    this.listen();

    /// Handle exceptions manager
    if (state case FailState state) {
      _isException(state);
    }
  }

  /// Listenable state
  late Listen<T> _listen;

  /// Current state
  T get state => _listen.state;

  /// Parent context
  BuildContext get context => _listen.context;

  /// Exception strategies on fail state
  List<ListenException> errorStrategies = [];

  /// Exception strategies on fail state
  static List<ListenException> strategies = [];

  /// [Getter] Handle local exception managers
  Function(FailResult fail)? onExceptions;

  /// [Static] Handle static exception manager
  static BlocExceptionManager? exceptionManager;

  /// On Fail getter with local instance onException or global exception manager
  void _onFail(FailResult fail) {
    // Handle custom onException callback
    if (onExceptions != null) {
      onExceptions?.call(fail);
      return;
    }

    // Find exception decoder on strategies list
    exceptionManager?.decode(
      listener: this,
      context: context,
      exception: fail.exception,
      strategies: [...strategies, ...errorStrategies],
    );
  }

  /// [Abstract] Listen changes on BLoC state
  void listen();

  /// [Event] On state
  void on<E>(Function(E state) onState) {
    if (state is E) {
      onState.call(state as E);
    }
  }

  /// [Event] On state do
  void only<E>(Function() onState) {
    if (state is E) {
      onState.call();
    }
  }

  /// [Event] Navigator pop
  void pop() {
    Navigator.of(context).pop();
  }

  /// [Event] Handle on exceptions
  void fail() {
    if (state case FailState state) {
      _onFail(state.fail);
    }
  }

  /// Handle exceptions manager or use case
  void _isException(FailState state) {
    if (this case BlocListenExceptions instance) {
      instance.exception(state.fail.exception);
    } else if (this is! BlocListenExceptionsIgnore) {
      _onFail(state.fail);
    }
  }
}
