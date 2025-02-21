import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';

typedef ListenerSingle<E> = Function(BuildContext context, E state);

class BlocListenOn<B extends StateStreamable<S>, S, E> extends BlocListener<B, S> {
  BlocListenOn({
    super.key,
    super.child,
    required ListenerSingle<E> listener,
  }) : super(
          listener: (context, state) {
            if (state is E) {
              listener.call(context, state as E);
            }
          },
        );
}
