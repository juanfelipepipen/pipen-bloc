import 'package:flutter/foundation.dart';
import 'package:pipen_bloc/src/cubit/cubit_fetch.dart';
import 'package:pipen_bloc/src/listen/bloc_listen.dart';
import 'package:pipen_bloc/src/models/fail_result.dart';

abstract class BlocListenFetch<T> extends BlocListen<FetchState<T>> {
  Function(FailResult fail)? failed;
  Function<A>(A error)? errors;
  Function(T result)? success;
  VoidCallback? loading;

  @override
  void listen() {
    if (state case FetchSuccess<T> success) {
      this.success?.call(success.result);
    }

    if (state case FetchFail fail) {
      this.failed?.call(fail.fail);
    }

    if (state is FetchLoading) {
      this.loading?.call();
    }
  }
}
