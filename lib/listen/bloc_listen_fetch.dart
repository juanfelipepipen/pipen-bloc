import 'package:flutter/foundation.dart';
import 'package:pipen_bloc/listen/bloc_listen.dart';
import 'package:pipen_bloc/models/fail_result.dart';
import 'package:pipen_bloc/cubit/cubit_fetch.dart';

abstract class BlocListenFetch<T> extends BlocListen<FetchState<T>> {
  VoidCallback? loading;
  Function(T result)? success;
  Function<A>(A error)? errors;
  Function(FailResult fail)? failed;

  @override
  void listen() {
    if (state case FetchSuccess<T> success) {
      this.success?.call(success.result);
    }

    if (state case FetchFail<T> fail) {
      this.failed?.call(fail.fail);
    }

    if (state case FetchLoading<T> _) {
      this.loading?.call();
    }
  }
}
