import 'package:flutter/material.dart';

class NavigationItem {
  final Widget page;
  final String icon;
  final String label;

  const NavigationItem({
    required this.page,
    required this.icon,
    required this.label,
  });
}
