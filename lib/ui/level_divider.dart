import 'package:flutter/material.dart';

class LevelDivider extends StatelessWidget {
  final int level;

  LevelDivider({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(level == 0 ? .5 : .2),
      margin: level == 0 ? null : EdgeInsets.symmetric(horizontal: 10.0),
    );
  }
}
