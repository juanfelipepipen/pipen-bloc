part of 'cubit_fetch.dart';

/// Fetch cubit that receives the future when [fetch] is called.
///
/// This variant is useful when the same cubit can execute different requests
/// or when the request depends on arguments known only at call time. It shares
/// the complete execution engine with [CubitFetch].
abstract class CubitFetchResolver<R> extends _CubitFetchBase<R> {
  CubitFetchResolver({super.pending = false});

  /// Starts [resolver]. Calls made while another fetch is loading are ignored.
  ///
  /// A future starts before it is passed to this method. For lazy execution,
  /// especially when using [FetchDelay], prefer [fetchTask].
  @protected
  void fetch(Future<R> resolver) =>
      _runFetch(() => resolver, onCancel: cancelResolver);

  /// Starts a lazily-created resolver with an optional per-request cancel hook.
  ///
  /// This is the preferred API for cancelable requests because the factory is
  /// not invoked if the cubit closes during a configured delay.
  @protected
  void fetchTask(
    Future<R> Function() resolver, {
    FutureOr<void> Function()? onCancel,
  }) => _runFetch(resolver, onCancel: onCancel ?? cancelResolver);
}
