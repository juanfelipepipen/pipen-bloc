import 'package:pipen_bloc/consumer/bloc_consumer_p.dart';
import 'package:pipen_bloc/cubit/cubit_fetch.dart';
import 'package:bloc/bloc.dart';

typedef BlocConsumerFetch<B extends StateStreamable<FetchState<S>>, S>
    = BlocConsumerP<B, FetchState<S>>;
