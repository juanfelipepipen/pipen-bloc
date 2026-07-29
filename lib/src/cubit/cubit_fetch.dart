import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pipen_bloc/src/abstract/fail_state.dart';
import 'package:pipen_bloc/src/abstract/loading_state.dart';
import 'package:pipen_bloc/src/models/fail_result.dart';

part 'fetch_state.dart';
part 'cubit_fetch_resolver.dart';
part 'cubit_fetch_resolver_pending.dart';

typedef _FetchResolver<R> = Future<R> Function();
typedef _FetchCancel = FutureOr<void> Function();

/// Shared execution engine for every fetch cubit in this library.
///
/// It owns state transitions, duplicate-call protection, cancellation and
/// lifecycle safety. Concrete cubits only decide how the resolver is supplied.
abstract class _CubitFetchBase<R> extends Cubit<FetchState<R>> {
  _CubitFetchBase({required bool pending})
    : super(pending ? FetchPending<R>() : FetchLoading<R>());

  /// Whether at least one fetch has been started.
  bool init = false;

  /// Stops the resource used by the active resolver, when supported.
  ///
  /// A [Future] is not inherently cancelable. Subclasses should override this
  /// hook when their HTTP client, subscription, isolate, or other resource
  /// exposes an explicit cancellation API.
  @protected
  FutureOr<void> cancelResolver() {}

  /// Operation used to discard a result after cancellation.
  CancelableOperation<R>? _operation;

  /// Set synchronously when [close] starts to prevent late emissions.
  bool _closing = false;

  /// Runs [resolver] unless an initialized fetch is already loading.
  ///
  /// [onCancel] must stop the underlying resource when it has its own
  /// cancellation API. Canceling an ordinary [Future] can only discard its
  /// eventual result; Dart cannot stop its internal work.
  void _runFetch(_FetchResolver<R> resolver, {_FetchCancel? onCancel}) {
    if (_closing || isClosed || (state is LoadingState && init)) return;

    init = true;
    loading();

    final execution = _FetchExecution(onCancel);

    Future<R> resolve() async {
      if (this case FetchDelay fetchDelay) {
        await execution.wait(fetchDelay.delay);
      }

      if (this is FetchDelaySome) {
        await execution.wait(const Duration(seconds: 3));
      }

      // Closing during a delay must prevent the resolver from being started.
      if (execution.isCanceled) throw const _FetchCanceled();

      if (this is FetchThrow || this is FetchThrowIn) {
        throw Exception('CubitFetch throw for test');
      }

      execution.resolverStarted = true;
      return resolver();
    }

    late final CancelableOperation<R> operation;
    operation = CancelableOperation<R>.fromFuture(
      resolve(),
      onCancel: execution.cancel,
    );
    _operation = operation;

    // Keep callbacks tied to this exact operation. An obsolete operation must
    // never overwrite the state produced by a newer fetch.
    unawaited(
      operation.value.then<void>(
        (result) {
          if (_canEmit(operation)) success(result);
        },
        onError: (Object error, StackTrace stackTrace) {
          if (_canEmit(operation)) fail(error, stackTrace);
        },
      ),
    );
  }

  bool _canEmit(CancelableOperation<R> operation) =>
      !_closing && !isClosed && identical(_operation, operation);

  /// Emits the loading state.
  void loading() {
    emit(FetchLoading<R>());
  }

  /// Emits a successful result.
  void success(R result) {
    emit(FetchSuccess<R>(result));
  }

  /// Converts an error and stack trace into a failure state.
  void fail(dynamic e, StackTrace s) {
    syncFail(FailResult(e, s));
  }

  /// Emits a failure that was already converted to [FailResult].
  void syncFail(FailResult fail) {
    emit(FetchFail<R>(fail));
  }

  /// Invokes [on] immediately when the current state is successful.
  void onSuccess(Function(R) on) {
    if (state case FetchSuccess<R> success) {
      on.call(success.result);
    }
  }

  /// Invokes [on] immediately when the current state is failed.
  void onFailed(Function on) {
    if (state is FetchFail<R>) {
      on.call();
    }
  }

  /// Invokes [on] immediately when the current state is loading or pending.
  void onLoading(Function on) {
    if (state is FetchLoading || state is FetchPending) {
      on.call();
    }
  }

  @override
  Future<void> close() async {
    // This flag must be set before the first await. A completed future may have
    // already scheduled its success/error callback in the microtask queue.
    _closing = true;
    try {
      await _operation?.cancel();
    } finally {
      // The cubit must close even if a third-party cancellation hook fails.
      await super.close();
    }
  }
}

/// Fetch cubit whose resolver is declared by the subclass.
///
/// The first fetch is scheduled in a microtask. This preserves automatic
/// loading while ensuring subclass fields have finished initialization before
/// [resolver] is read.
abstract class CubitFetch<R> extends _CubitFetchBase<R> {
  CubitFetch({bool pending = false}) : super(pending: pending) {
    if (!pending) scheduleMicrotask(fetch);
  }

  /// Produces the value emitted in [FetchSuccess].
  @protected
  Future<R> get resolver;

  /// Starts the declared [resolver]. Calls made while loading are ignored.
  void fetch() => _runFetch(() => resolver, onCancel: cancelResolver);
}

/// A [CubitFetch] that remains pending until [CubitFetch.fetch] is called.
abstract class CubitFetchPending<R> extends CubitFetch<R> {
  CubitFetchPending() : super(pending: true);
}

/// Adds an artificial delay before resolving.
///
/// This interface is retained for compatibility and is mainly useful in tests.
interface class FetchDelay {
  Duration get delay => throw UnimplementedError();
}

/// Adds a three-second artificial delay. Prefer [FetchDelay] in new code.
interface class FetchDelaySome {}

/// Forces the fetch to fail. Intended for tests.
interface class FetchThrow {}

/// Combines [FetchThrow] behavior with a configurable [FetchDelay].
interface class FetchThrowIn extends FetchDelay {}

/// Cancellation state shared with delay and resolver execution.
final class _FetchExecution {
  _FetchExecution(this._onCancel);

  final _FetchCancel? _onCancel;
  final Completer<void> _canceled = Completer<void>();

  bool resolverStarted = false;

  bool get isCanceled => _canceled.isCompleted;

  /// Waits until either [duration] elapses or this execution is canceled.
  Future<void> wait(Duration duration) async {
    if (isCanceled) return;

    await Future.any<void>([Future<void>.delayed(duration), _canceled.future]);
  }

  /// Marks this execution as canceled and wakes any active delay.
  FutureOr<void> cancel() {
    if (isCanceled) return Future<void>.value();

    _canceled.complete();
    if (resolverStarted) return _onCancel?.call();
  }
}

/// Internal signal used only to finish a resolver canceled during a delay.
final class _FetchCanceled implements Exception {
  const _FetchCanceled();
}
