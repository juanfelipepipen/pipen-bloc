import 'package:flutter/widgets.dart';

class PipenBuilderContainer extends StatefulWidget {
  const PipenBuilderContainer({super.key, required this.child, this.init});

  final VoidCallback? init;
  final Widget child;

  @override
  State<PipenBuilderContainer> createState() => _PipenBuilderContainerState();
}

class _PipenBuilderContainerState extends State<PipenBuilderContainer> {
  @override
  void initState() {
    widget.init?.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
