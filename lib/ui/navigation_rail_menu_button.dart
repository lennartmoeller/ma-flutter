import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/skeleton.dart';

class NavigationRailMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NavigationRailMenuButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: Skeleton.headerHeight - 16.0,
          padding: EdgeInsets.only(right: lerpDouble(0, 140, animation.value)!),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }
}
