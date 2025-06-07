import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:pipen_bloc/src/cubit/cubit_fetch.dart';

class BlocBuilderFetchNullable<B extends FetchBlocStreamable<S>, S> extends StatelessWidget {
  const BlocBuilderFetchNullable({super.key, required this.builder});

  final Function(BuildContext context, FetchState<S> state, B bloc, S? result) builder;

  @override
  Widget build(BuildContext context) => BlocBuilder<B, FetchState<S>>(
        builder: (context, state) => builder(
          context,
          state,
          context.read<B>(),
          state is FetchSuccess<S> ? (state).result : null,
        ),
      );
}
