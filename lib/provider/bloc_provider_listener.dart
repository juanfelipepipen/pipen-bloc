import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pipen_bloc/listen/bloc_listen.dart';
import 'package:pipen_bloc/listener/bloc_listenable.dart';
import 'package:pipen_bloc/provider/bloc_provider_p.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

class BlocProviderListener<B extends StateStreamableSource<S>, S> extends StatelessWidget {
  BlocProviderListener({
    super.key,
    this.init,
    this.child,
    this.builder,
    required this.create,
    required this.listener,
  }) {
    assert(child != null || builder != null);
  }

  final Widget Function(BuildContext context, S state, B bloc)? builder;
  final Function(BuildContext context, B bloc)? init;
  final BlocListen<S> listener;
  final Create<B> create;
  final Widget? child;

  @override
  Widget build(BuildContext context) => BlocProviderP<B, S>(
        init: init,
        create: create,
        builder: (context, state, bloc) => BlocListenable<B, S>(
          listener: listener,
          child: child ?? builder!.call(context, state, bloc),
        ),
      );
}
