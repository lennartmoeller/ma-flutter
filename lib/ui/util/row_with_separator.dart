import 'package:flutter/material.dart';

class RowWithSeparator extends StatelessWidget {
  final Widget separator;
  final List<Widget> children;

  const RowWithSeparator({
    super.key,
    required this.separator,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return Row();
    return Row(
      children: List<Widget>.generate(children.length * 2 - 1, (index) {
        return index.isEven ? children[index ~/ 2] : separator;
      }),
    );
  }
}
