part of 'cubit_fetch.dart';

abstract class CubitFetchResolverPending<R> extends CubitFetchResolver<R> {
  CubitFetchResolverPending() : super(pending: true);
}
