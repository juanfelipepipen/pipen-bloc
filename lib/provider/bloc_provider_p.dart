import 'package:pipen_bloc/builder/bloc_builder_p.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

class BlocProviderP<B extends StateStreamableSource<S>, S> extends StatelessWidget {
  const BlocProviderP({super.key, required this.create, this.builder, this.child, this.init});

  final Widget Function(BuildContext context, S state, B bloc)? builder;
  final Function(BuildContext context, B bloc)? init;
  final Create<B> create;
  final Widget? child;

  @override
  Widget build(BuildContext context) => BlocProvider<B>(
        lazy: false,
        create: create,
        child: BlocBuilderP<B, S>(
          init: init,
          builder: builder,
          child: child,
        ),
      );
}
