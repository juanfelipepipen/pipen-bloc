import 'package:pipen_echo/pipen_echo.dart';
import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'channel_state.dart';

abstract class ChannelPendingCubit<T> extends Cubit<ChannelCubitState<T>> {
  ChannelPendingCubit({required T initial})
    : super(ChannelCubitState(value: initial, status: ChannelConnectionState.connecting));

  CancelableOperation<ChannelConnector>? _connector;
  ChannelConnector? _channelConnection;
  LaravelPrivateChannel? _channel;

  @protected
  void start({required LaravelPrivateChannel channel}) {
    this._channel = channel;
    final options = PusherEchoOptions(onChangeState: _updateStatus);
    _connector = CancelableOperation.fromFuture(channel.connect(options: options));
    _connector?.then((connection) {
      _channelConnection = connection;
    });
  }

  @protected
  void updater({required Future<T> fetcher}) {}

  /// Update state value
  void update(T value) {
    emit(state.copyWith(value: value));
  }

  /// Update the channel connection status
  void _updateStatus(ChannelConnectionState status) {
    print(status);
    emit(state.copyWith(status: status));
  }

  @override
  Future<void> close() {
    _connector?.cancel();
    _channelConnection?.close();
    return super.close();
  }
}
