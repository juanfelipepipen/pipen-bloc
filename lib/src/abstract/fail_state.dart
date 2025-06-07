import 'package:pipen_bloc/src/models/fail_result.dart';

abstract class FailState {
  /// Event emitted, example: exception throw
  FailResult get fail;
}
