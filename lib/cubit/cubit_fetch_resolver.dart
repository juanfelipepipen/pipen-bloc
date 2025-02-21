part of 'cubit_fetch.dart';

abstract class CubitFetchResolver<R> extends Cubit<FetchState<R>> {
  CubitFetchResolver({
    bool pending = false,
  }) : super(pending ? FetchPending<R>() : FetchLoading<R>());

  bool init = false;

  CancelableOperation<R>? _resolver;

  /// Fetch resolver
  void fetch(Future<R> resolver) {
    if (state is! LoadingState || !init) {
      init = true;
      emit(FetchLoading<R>());
      _resolver = CancelableOperation.fromFuture(resolver);
      _resolver?.value.then((result) {
        emit(FetchSuccess<R>(result));
      }).catchError((e, s) {
        emit(FetchFail<R>(FailResult(e, s)));
      });
    }
  }

  @override
  Future<void> close() {
    _resolver?.cancel();
    return super.close();
  }
}
