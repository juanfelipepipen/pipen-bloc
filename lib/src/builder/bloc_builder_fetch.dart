import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:pipen_bloc/src/builder/bloc_builder_p.dart';
import 'package:pipen_bloc/src/cubit/cubit_fetch.dart';

class BlocBuilderFetch<B extends StateStreamable<FetchState<S>>, S> extends StatelessWidget {
  const BlocBuilderFetch({super.key, required this.builder});

  final Widget Function(BuildContext context, FetchState<S> state, B bloc) builder;

  @override
  Widget build(BuildContext context) => BlocBuilderP<B, FetchState<S>>(
        builder: builder,
      );
}
