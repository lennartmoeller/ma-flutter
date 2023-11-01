import 'package:ma_flutter/utility/navigation/navigation_item.dart';
import 'package:flutter/material.dart';

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

    AnimatedSwitcher mainArea = AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: widget.navigationItems[_currentPageIndex].page,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          // NavigationBar for thin devices
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              destinations: widget.navigationItems
                  .map((item) => item.buildNavigationBarDestination())
                  .toList(),
              onDestinationSelected: (value) {
                setState(() {
                  _currentPageIndex = value;
                });
              },
              selectedIndex: _currentPageIndex,
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
                    // set the elevation to match the NavigationBar elevation
                    backgroundColor: ElevationOverlay.colorWithOverlay(
                      colorScheme.surface,
                      colorScheme.primary,
                      3.0,
                    ),
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
