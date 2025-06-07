import 'package:bloc/bloc.dart';
import 'package:pipen_bloc/src/consumer/bloc_consumer_p.dart';
import 'package:pipen_bloc/src/cubit/cubit_fetch.dart';

typedef BlocConsumerFetch<B extends StateStreamable<FetchState<S>>, S>
    = BlocConsumerP<B, FetchState<S>>;
