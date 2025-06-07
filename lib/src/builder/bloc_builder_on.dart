import 'package:flutter/widgets.dart';
import 'package:pipen_bloc/src/models/builder_model.dart';

class BlocBuilderOn<E> extends StatelessWidget {
  const BlocBuilderOn({required this.builder, required this.child, this.difference, super.key});

  final Widget Function(E state) child;
  final BuilderModel builder;
  final Widget? difference;

  @override
  Widget build(BuildContext context) => builder.builder((context, state) {
    if (state is E) {
      return child.call(state);
    }
    return difference ?? const SizedBox.shrink();
  });
}
