part of 'cubit_fetch.dart';

typedef FetchBlocStreamable<S> = StateStreamable<FetchState<S>>;

/// Base state for the lifecycle of a single asynchronous fetch.
@immutable
sealed class FetchState<R> extends Equatable {
  const FetchState();

  @override
  List<Object?> get props => [];
}

/// The resolver is currently running.
final class FetchLoading<R> extends FetchState<R> implements LoadingState {
  const FetchLoading();
}

/// No resolver has been started yet.
final class FetchPending<R> extends FetchState<R> {
  const FetchPending();
}

/// The resolver completed with [result].
final class FetchSuccess<R> extends FetchState<R> {
  const FetchSuccess(this.result);

  final R result;

  /// Creates another success state with a replacement result.
  FetchSuccess<R> copy(R result) => FetchSuccess<R>(result);

  @override
  List<Object?> get props => [result];
}

/// The resolver completed with a captured failure.
final class FetchFail<R> extends FetchState<R> implements FailState {
  const FetchFail(this.fail);

  @override
  final FailResult fail;

  @override
  List<Object?> get props => [fail];
}
