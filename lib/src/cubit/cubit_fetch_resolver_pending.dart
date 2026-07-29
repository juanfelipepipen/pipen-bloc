part of 'cubit_fetch.dart';

/// A [CubitFetchResolver] that starts in [FetchPending].
///
/// The subclass decides when to call [CubitFetchResolver.fetch] or
/// [CubitFetchResolver.fetchTask].
abstract class CubitFetchResolverPending<R> extends CubitFetchResolver<R> {
  CubitFetchResolverPending() : super(pending: true);
}
