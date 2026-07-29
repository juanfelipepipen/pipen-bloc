import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pipen_bloc/pipen_bloc.dart';

void main() {
  group('CubitFetch execution modes', () {
    test('automatic fetch starts after subclass initialization', () async {
      final cubit = _AutomaticFetch(7);

      expect(cubit.state, isA<FetchLoading<int>>());
      await expectLater(
        cubit.stream,
        emits(
          isA<FetchSuccess<int>>().having((state) => state.result, 'result', 7),
        ),
      );

      await cubit.close();
    });

    test('manual resolver uses the shared state engine', () async {
      final cubit = _ManualFetch();

      expect(cubit.state, isA<FetchPending<int>>());
      cubit.resolve(Future<int>.value(11));

      await expectLater(
        cubit.stream,
        emits(
          isA<FetchSuccess<int>>().having(
            (state) => state.result,
            'result',
            11,
          ),
        ),
      );

      await cubit.close();
    });
  });

  group('CubitFetch cancellation', () {
    test('close delegates cancellation to the active resolver', () async {
      final work = _CancelableWork();
      final cubit = _CancelableFetch(work);
      final emittedStates = <FetchState<int>>[];
      final subscription = cubit.stream.listen(emittedStates.add);

      cubit.fetch();
      await work.started.future;
      await cubit.close();

      expect(work.wasCanceled, isTrue);
      expect(emittedStates.whereType<FetchSuccess<int>>(), isEmpty);
      expect(emittedStates.whereType<FetchFail<int>>(), isEmpty);

      await subscription.cancel();
    });

    test('close during a delay does not start the resolver', () async {
      final cubit = _DelayedFetch();

      cubit.fetch();
      await cubit.close();
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(cubit.resolverWasStarted, isFalse);
    });
  });
}

final class _AutomaticFetch extends CubitFetch<int> {
  _AutomaticFetch(this.value);

  final int value;

  @override
  Future<int> get resolver async => value;
}

final class _ManualFetch extends CubitFetchResolverPending<int> {
  void resolve(Future<int> result) => fetch(result);
}

final class _CancelableWork {
  final Completer<void> started = Completer<void>();
  final Completer<int> result = Completer<int>();

  bool wasCanceled = false;

  Future<int> run() {
    started.complete();
    return result.future;
  }

  void cancel() {
    wasCanceled = true;
    if (!result.isCompleted) {
      result.completeError(const _WorkCanceled());
    }
  }
}

final class _CancelableFetch extends CubitFetchPending<int> {
  _CancelableFetch(this.work);

  final _CancelableWork work;

  @override
  Future<int> get resolver => work.run();

  @override
  void cancelResolver() => work.cancel();
}

final class _DelayedFetch extends CubitFetchPending<int> implements FetchDelay {
  bool resolverWasStarted = false;

  @override
  Duration get delay => const Duration(milliseconds: 20);

  @override
  Future<int> get resolver async {
    resolverWasStarted = true;
    return 1;
  }
}

final class _WorkCanceled implements Exception {
  const _WorkCanceled();
}
