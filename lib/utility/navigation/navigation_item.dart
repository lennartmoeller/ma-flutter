import 'package:flutter/material.dart';

class NavigationItem {
  final Widget page;
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.page,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.label,
  });

  NavigationDestination buildNavigationBarDestination() {
    return NavigationDestination(
      icon: Icon(unselectedIcon),
      selectedIcon: Icon(selectedIcon),
      label: label,
    );
  }

  NavigationRailDestination buildNavigationRailDestination() {
    return NavigationRailDestination(
      icon: Icon(unselectedIcon),
      selectedIcon: Icon(selectedIcon),
      label: Text(label),
    );
  }
}
