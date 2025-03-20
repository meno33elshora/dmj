import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatefulWidget {
  final double value;
  const ProgressIndicatorWidget({super.key, required this.value});

  @override
  State<ProgressIndicatorWidget> createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Color> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    );
    animation = Tween<Color>(
      begin: Colors.green,
      end: Colors.red,
    ).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 100,
      // width: 100,
      child: CircularProgressIndicator.adaptive(
        value: widget.value,
        valueColor: animation,
        backgroundColor: Colors.white,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
