import 'package:pipen_bloc/builder/pipen_builder_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter/widgets.dart';

class BlocBuilderP<B extends bloc.StateStreamable<S>, S> extends StatelessWidget {
  final Widget Function(BuildContext context, S state, B bloc)? builder;
  final Function(BuildContext context, B bloc)? init;
  final Widget? child;

  BlocBuilderP({required this.builder, this.init, super.key, this.child}) {
    assert(child != null || builder != null);
  }

  @override
  Widget build(BuildContext context) => bloc.BlocBuilder<B, S>(
    builder:
        (context, state) => PipenBuilderContainer(
          init: () => init?.call(context, context.read<B>()),
          child: child ?? builder!.call(context, state, context.read<B>()),
        ),
  );
}
