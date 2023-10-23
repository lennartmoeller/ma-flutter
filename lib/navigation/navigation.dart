import 'package:flutter/material.dart';

import 'navigation_item.dart';

class Navigation extends StatefulWidget {
  final List<NavigationItem> navigationItems;

  const Navigation({super.key, required this.navigationItems});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    ColoredBox mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: widget.navigationItems[_currentPageIndex].page,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          // NavigationBar for thin devices
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              backgroundColor: colorScheme.background,
              destinations: widget.navigationItems
                  .map((item) => item.buildNavigationBarDestination())
                  .toList(),
              onDestinationSelected: (value) {
                setState(() {
                  _currentPageIndex = value;
                });
              },
              selectedIndex: _currentPageIndex,
              surfaceTintColor: Colors.transparent, // removes default color
            ),
            body: mainArea,
          );
        } else {
          // NavigationRail for wide devices
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: colorScheme.background,
                    destinations: widget.navigationItems
                        .map((item) => item.buildNavigationRailDestination())
                        .toList(),
                    extended: constraints.maxWidth >= 800,
                    onDestinationSelected: (value) {
                      setState(() {
                        _currentPageIndex = value;
                      });
                    },
                    selectedIndex: _currentPageIndex,
                  ),
                ),
                Expanded(child: mainArea),
              ],
            ),
          );
        }
      },
    );
  }
}
