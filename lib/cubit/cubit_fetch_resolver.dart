part of 'cubit_fetch.dart';

abstract class CubitFetchResolver<R> extends Cubit<FetchState<R>> {
  CubitFetchResolver({bool pending = false})
    : super(pending ? FetchPending<R>() : FetchLoading<R>());

  bool init = false;

  CancelableOperation<R>? _resolver;

  /// Fetch resolver
  @protected
  void fetch(Future<R> resolver) {
    if (state is! LoadingState || !init) {
      init = true;
      emit(FetchLoading<R>());

      resolvable() async {
        if (this case FetchDelay fetchDelay) {
          await Future.delayed(fetchDelay.delay);
        }

        if (this is FetchDelaySome) {
          await Future.delayed(Duration(seconds: 3));
        }

        if (this is FetchThrow || this is FetchThrowIn) {
          throw Exception('CubitFetch throw for test');
        }

        return await resolver;
      }

      _resolver = CancelableOperation.fromFuture(resolvable());
      _resolver?.value
          .then((result) {
            emit(FetchSuccess<R>(result));
          })
          .catchError((e, s) {
            emit(FetchFail<R>(FailResult(e, s)));
          });
    }
  }

  /// Emit loading state
  void loading() {
    emit(FetchLoading<R>());
  }

  /// Emit success state
  void success(R result) {
    emit(FetchSuccess<R>(result));
  }

  /// Emit fail state
  void fail(dynamic e, StackTrace s) {
    syncFail(FailResult(e, s));
  }

  /// Sync fail from exists fail result
  void syncFail(FailResult fail) {
    emit(FetchFail<R>(fail));
  }

  /// Handle if state is success
  void onSuccess(Function(R) on) {
    if (state case FetchSuccess<R> success) {
      on.call(success.result);
    }
  }

  @override
  Future<void> close() {
    _resolver?.cancel();
    return super.close();
  }
}
