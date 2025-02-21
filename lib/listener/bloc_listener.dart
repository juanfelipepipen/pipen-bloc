import 'package:pipen_bloc/builder/bloc_builder_p.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/listen/bloc_listen.dart';

class BlocListenerP<B extends StateStreamable<S>, S> extends StatelessWidget {
  const BlocListenerP({
    super.key,
    this.bloc,
    this.child,
    this.listen,
    this.builder,
    required this.listener,
  });

  final Widget Function(BuildContext context, S state, B bloc)? builder;
  final BlocWidgetListener<S>? listener;
  final BlocListen<S>? listen;
  final Widget? child;
  final B? bloc;

  Widget? getChild(BuildContext context) {
    if (child != null) {
      return child;
    } else if (builder != null) {
      return BlocBuilderP<B, S>(builder: builder);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => BlocListener<B, S>(
        bloc: bloc,
        listener: listener ??
            (context, state) {
              listen?.handle(listen: (context, state));
            },
        child: getChild(context),
      );
}
