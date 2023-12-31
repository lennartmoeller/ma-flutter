import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';

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
          height: SkeletonState.headerHeightWideDevices - 16.0,
          padding: EdgeInsets.only(right: lerpDouble(0, 140, animation.value)!),
          child: Center(
            child: IconButton(
              icon: CustomIcon(name: "bars"),
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }
}
