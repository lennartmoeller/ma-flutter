import 'package:flutter/material.dart';

abstract class NavigablePage extends StatefulWidget {
  String get icon;

  String get label;

  Widget? getFloatingActionButton(BuildContext context) {
    return null;
  }

  List<Widget> getHeaderLeading(BuildContext context) {
    return [];
  }

  List<Widget> getHeaderTrailing(BuildContext context) {
    return [];
  }

  const NavigablePage({super.key});
}
