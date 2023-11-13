import 'package:flutter/material.dart';

class ColumnWithSeparator extends StatelessWidget {
  final Widget separator;
  final List<Widget> children;

  const ColumnWithSeparator({
    super.key,
    required this.separator,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return Column();
    return Column(
      children: List<Widget>.generate(children.length * 2 - 1, (index) {
        return index.isEven ? children[index ~/ 2] : separator;
      }),
    );
  }
}
