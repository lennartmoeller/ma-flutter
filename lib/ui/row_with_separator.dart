import 'package:flutter/material.dart';

class RowWithSpacing extends StatelessWidget {
  final double spacing;
  final List<Widget> children;

  const RowWithSpacing({
    super.key,
    required this.spacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return Row();
    return Row(
      children: List<Widget>.generate(children.length * 2 - 1, (index) {
        return index.isEven ? children[index ~/ 2] : SizedBox(width: spacing);
      }),
    );
  }
}
