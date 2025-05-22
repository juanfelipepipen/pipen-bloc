import 'package:flutter/widgets.dart';

abstract class ListenException {
  /// Check if exceptions has strategy
  bool callable(dynamic instance, dynamic exception);

  /// Prepare exception strategy
  void handle(BuildContext context, dynamic listener, dynamic exception);
}
