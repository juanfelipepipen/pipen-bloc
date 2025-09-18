import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pipen_bloc/pipen_bloc.dart';
import 'package:flutter/cupertino.dart';

class BlocListenerFetchSuccess<B extends StateStreamable<FetchState<S>>, S>
    extends StatelessWidget {
  const BlocListenerFetchSuccess({
    super.key,
    this.pop = false,
    required this.child,
    required this.onSuccess,
  });

  final bool pop;
  final Function(S value) onSuccess;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocListenerFetch<B, S>(listener: _Listener<S>(onSuccess: onSuccess), child: child);
}

class _Listener<S> extends BlocListenFetch<S> {
  _Listener({required this.onSuccess});

  @override
  get success => onSuccess;

  final Function(S value) onSuccess;
}
