import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pipen_bloc/pipen_bloc.dart';
import 'package:flutter/cupertino.dart';

class BlocListenerFetchSuccess<B extends StateStreamable<FetchState<S>>, S>
    extends BlocListenerBase<B, FetchState<S>> {
  factory BlocListenerFetchSuccess.pop({
    Key? key,
    Widget? child,
    bool? ignoreExceptions,
    VoidCallback? callback,
    Function(S value)? onSuccess,
  }) {
    return BlocListenerFetchSuccess._(
      key: key,
      callback: callback,
      popOnSuccess: true,
      onSuccess: onSuccess,
      ignoreExceptions: ignoreExceptions,
      child: child,
    );
  }

  factory BlocListenerFetchSuccess({
    Key? key,
    Widget? child,
    bool? ignoreExceptions,
    VoidCallback? callback,
    Function(S value)? onSuccess,
  }) {
    return BlocListenerFetchSuccess._(
      key: key,
      callback: callback,
      popOnSuccess: false,
      onSuccess: onSuccess,
      ignoreExceptions: ignoreExceptions,
      child: child,
    );
  }

  BlocListenerFetchSuccess._({
    super.key,
    super.child,
    VoidCallback? callback,
    bool? ignoreExceptions,
    required bool popOnSuccess,
    Function(S value)? onSuccess,
  }) : super(
         listener: (context, state) {
           _Listener(
             callback: callback,
             onSuccess: onSuccess,
             popOnSuccess: popOnSuccess,
             ignoreExceptions: ignoreExceptions,
           ).handle(listen: (context: context, state: state));
         },
       );
}

class _Listener<S> extends BlocListenFetch<S>
    implements BlocListenExceptionsIgnoreCondition {
  _Listener({
    this.callback,
    this.onSuccess,
    required this.popOnSuccess,
    bool? ignoreExceptions,
  }) : _ignoreExceptions = ignoreExceptions ?? false;

  final bool popOnSuccess, _ignoreExceptions;
  final Function(S value)? onSuccess;
  final VoidCallback? callback;

  @override
  get success => (result) {
    if (popOnSuccess) {
      pop();
    }

    callback?.call();
    onSuccess?.call(result);
  };

  @override
  bool get ignore => _ignoreExceptions;
}
