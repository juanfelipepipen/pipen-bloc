import 'package:flutter/widgets.dart';

abstract class ExceptionStrategy {
  /// Check if exceptions has strategy
  bool callable(dynamic instance, dynamic exception);

  /// Prepare exception strategy
  void handle(BuildContext context, dynamic instance, dynamic exception);
}
