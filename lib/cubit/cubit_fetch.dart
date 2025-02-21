import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pipen_bloc/abstract/fail_state.dart';
import 'package:pipen_bloc/abstract/loading_state.dart';
import 'package:pipen_bloc/models/fail_result.dart';

part 'fetch_state.dart';
part 'cubit_fetch_resolver.dart';
part 'cubit_fetch_resolver_pending.dart';

abstract class CubitFetch<R> extends Cubit<FetchState<R>> {
  CubitFetch({bool pending = false}) : super(pending ? FetchPending<R>() : FetchLoading<R>());

  bool init = false;

  @protected
  Future<R> get resolver;

  /// Future resolver async
  CancelableOperation<R>? _resolver;

  /// Fetch resolver
  void fetch() {
    if (state is! LoadingState || !init) {
      init = true;
      loading();
      _resolver = CancelableOperation.fromFuture(resolver);
      _resolver?.value.then((result) {
        success(result);
      }).catchError((e, s) {
        fail(e, s);
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
    emit(FetchFail<R>(FailResult(e, s)));
  }

  @override
  Future<void> close() {
    _resolver?.cancel();
    return super.close();
  }
}

abstract class CubitFetchPending<R> extends CubitFetch<R> {
  CubitFetchPending() : super(pending: true);
}
