import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/listen/bloc_listen.dart';

class BlocConsumerP<B extends bloc.StateStreamable<S>, S> extends StatelessWidget {
  const BlocConsumerP({required this.builder, required this.listener, super.key});

  final Widget Function(BuildContext context, S state, B bloc) builder;
  final BlocListen<S> listener;

  @override
  Widget build(BuildContext context) => bloc.BlocConsumer<B, S>(
        listener: (context, state) => listener.handle(listen: (context, state)),
        builder: (context, state) {
          final bloc = context.read<B>();
          return builder.call(context, state, bloc);
        },
      );
}
