import 'package:pipen_bloc/builder/bloc_builder_p.dart';
import 'package:pipen_bloc/cubit/cubit_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';

class BlocBuilderFetch<B extends StateStreamable<FetchState<S>>, S> extends StatelessWidget {
  const BlocBuilderFetch({super.key, required this.builder});

  final Widget Function(BuildContext context, FetchState<S> state, B bloc) builder;

  @override
  Widget build(BuildContext context) => BlocBuilderP<B, FetchState<S>>(
        builder: builder,
      );
}
