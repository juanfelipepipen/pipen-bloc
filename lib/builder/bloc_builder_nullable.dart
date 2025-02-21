import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

class BlocBuilderNullable<B extends StateStreamable<S>, S, O> extends StatelessWidget {
  const BlocBuilderNullable({super.key, required this.builder});

  final Function(BuildContext context, S state, O? nullable, B bloc) builder;

  @override
  Widget build(BuildContext context) => BlocBuilder<B, S>(
        builder: (context, state) => builder(
          context,
          state,
          state is O ? state as O : null,
          context.read<B>(),
        ),
      );
}
