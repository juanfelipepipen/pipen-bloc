import 'package:pipen_bloc/pipen_bloc.dart';
import 'channel_state.dart';

typedef BlocListenChannel<T> = BlocListen<ChannelCubitState<T>>;
