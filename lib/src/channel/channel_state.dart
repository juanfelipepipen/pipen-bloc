import 'package:pipen_echo/pipen_echo.dart';
import 'package:flutter/cupertino.dart';

@immutable
class ChannelCubitState<T> {
  const ChannelCubitState({required this.value, required this.status});

  final ChannelConnectionState status;
  final T value;

  ChannelCubitState<T> copyWith({T? value, ChannelConnectionState? status}) =>
      ChannelCubitState<T>(status: status ?? this.status, value: value ?? this.value);
}
