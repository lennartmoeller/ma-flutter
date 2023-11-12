import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';

class CustomDivider extends StatelessWidget {
  final int level;

  CustomDivider({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: SkeletonState.colorScheme.outline.withOpacity(level == 0 ? .5 : .2),
      margin: level == 0 ? null : EdgeInsets.symmetric(horizontal: 10.0),
    );
  }
}
