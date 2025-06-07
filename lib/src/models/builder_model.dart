import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

final class BuilderModel<B extends StateStreamable<S>, S> {
  const BuilderModel();

  /// Bloc builder
  BlocBuilder builder(Widget Function(BuildContext context, S state) builder) {
    return BlocBuilder<B, S>(builder: builder);
  }

  /// Subscribe to listener
  StreamSubscription<S> subscribe(BuildContext context, Function(S state) onData) {
    return context.read<B>().stream.listen(onData);
  }
}
