import 'package:pipen_bloc/src/channel/channel_pending_cubit.dart';
import 'package:pipen_echo/pipen_echo.dart';

abstract class ChannelCubit<T> extends ChannelPendingCubit<T> {
  ChannelCubit({required super.initial});

  LaravelPrivateChannel get channel;
  ChannelConnector? connector;
  Future<T> get fetcher;

  /// Connect to channel
  void connect() async {
    start(channel: channel);
  }

  @override
  Future<void> close() {
    connector?.close();
    return super.close();
  }
}
