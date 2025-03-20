import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimateWidgetItem extends StatelessWidget {
  final Widget item;
  final double? horizontalOffset;
  final double? verticalOffset;
  final int? indexPositionItem;
  const AnimateWidgetItem({
    super.key,
    required this.item,
    this.horizontalOffset,
    this.verticalOffset,
    this.indexPositionItem,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: indexPositionItem ?? 1,
      duration: const Duration(milliseconds: 800),
      child: SlideAnimation(
        horizontalOffset: horizontalOffset,
        verticalOffset: verticalOffset,
        child: FadeInAnimation(
          child: item,
        ),
      ),
    );
  }
}
