import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pipen_bloc/pipen_bloc.dart';
import 'package:flutter/cupertino.dart';

class BlocListenerFetchFailed<B extends StateStreamable<FetchState<S>>, S> extends StatelessWidget {
  const BlocListenerFetchFailed({
    super.key,
    this.pop = false,
    required this.child,
    required this.onFailed,
  });

  final Function(FailResult value) onFailed;
  final Widget child;
  final bool pop;

  @override
  Widget build(BuildContext context) =>
      BlocListenerFetch<B, S>(listener: _Listener<S>(onFailed: onFailed), child: child);
}

class _Listener<S> extends BlocListenFetch<S> implements BlocListenExceptionsIgnore {
  _Listener({required this.onFailed});

  @override
  get failed => onFailed;

  final Function(FailResult value) onFailed;
}
