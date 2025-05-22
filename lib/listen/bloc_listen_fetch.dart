import 'package:flutter/foundation.dart';
import 'package:pipen_bloc/listen/bloc_listen.dart';
import 'package:pipen_bloc/models/fail_result.dart';
import 'package:pipen_bloc/cubit/cubit_fetch.dart';

abstract class BlocListenFetch<T> extends BlocListen<FetchState<T>> {
  Function(FailResult fail)? failed;
  Function<A>(A error)? errors;
  Function(T result)? success;
  VoidCallback? loading;

  @override
  void listen() {
    print("LISTANDO ALV>>>>");
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
