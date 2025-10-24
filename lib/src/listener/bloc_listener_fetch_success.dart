import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pipen_bloc/pipen_bloc.dart';
import 'package:flutter/cupertino.dart';

class BlocListenerFetchSuccess<B extends StateStreamable<FetchState<S>>, S>
    extends BlocListenerBase<B, FetchState<S>> {
  factory BlocListenerFetchSuccess.pop({
    Key? key,
    Widget? child,
    VoidCallback? callback,
    Function(S value)? onSuccess,
  }) {
    return BlocListenerFetchSuccess._(
      key: key,
      callback: callback,
      popOnSuccess: true,
      onSuccess: onSuccess,
      child: child,
    );
  }

  factory BlocListenerFetchSuccess({
    Key? key,
    Widget? child,
    VoidCallback? callback,
    Function(S value)? onSuccess,
  }) {
    return BlocListenerFetchSuccess._(
      key: key,
      callback: callback,
      popOnSuccess: false,
      onSuccess: onSuccess,
      child: child,
    );
  }

  BlocListenerFetchSuccess._({
    super.key,
    super.child,
    VoidCallback? callback,
    required bool popOnSuccess,
    Function(S value)? onSuccess,
  }) : super(
         listener: (context, state) {
           _Listener(
             callback: callback,
             onSuccess: onSuccess,
             popOnSuccess: popOnSuccess,
           ).handle(listen: (context: context, state: state));
         },
       );
}

class _Listener<S> extends BlocListenFetch<S> {
  _Listener({this.callback, this.onSuccess, required this.popOnSuccess});

  final Function(S value)? onSuccess;
  final VoidCallback? callback;
  final bool popOnSuccess;

  @override
  get success => (result) {
    if (popOnSuccess) {
      pop();
    }

    callback?.call();
    onSuccess?.call(result);
  };
}
