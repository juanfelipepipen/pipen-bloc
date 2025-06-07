import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pipen_bloc/src/abstract/fail_state.dart';
import 'package:pipen_bloc/src/abstract/loading_state.dart';
import 'package:pipen_bloc/src/models/fail_result.dart';

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
            success(result);
          })
          .catchError((e, s) {
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

  /// Handle if state is failed
  void onFailed(Function on) {
    if (state is FetchFail<R>) {
      on.call();
    }
  }

  /// Handle if state is loading
  void onLoading(Function on) {
    if (state is FetchLoading || state is FetchPending) {
      on.call();
    }
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

interface class FetchDelay {
  Duration get delay => throw UnimplementedError();
}

interface class FetchDelaySome {}

interface class FetchThrow {}

interface class FetchThrowIn extends FetchDelay {}
