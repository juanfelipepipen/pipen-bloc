import 'package:pipen_bloc/models/fail_result.dart';

abstract class FailState {
  /// Event emitted, example: exception throw
  FailResult get fail;
}
