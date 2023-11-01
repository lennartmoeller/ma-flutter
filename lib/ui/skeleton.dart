import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/header.dart';
import 'package:ma_flutter/ui/navigation_item.dart';
import 'package:ma_flutter/ui/navigation_rail_menu_button.dart';

class Skeleton extends StatefulWidget {
  final List<NavigationItem> navigationItems;

  const Skeleton({super.key, required this.navigationItems});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  static const compressedSidebarWidth = 80.00;
  static const extendedSidebarWidth = 220.0;
  static const minContentWidth = 500.0;
  static const navItemUnselectedOpacity = 0.55;

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    IconThemeData iconTheme = Theme.of(context).iconTheme;

    TextStyle navItemBaseTextStyle = textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 13,
      letterSpacing: 0.2,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < (minContentWidth + compressedSidebarWidth)) {
          // NavigationBar for thin devices
          return Scaffold(
            bottomNavigationBar: NavigationBar(
              destinations: widget.navigationItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(
                        item.unselectedIcon,
                        color: colorScheme.onSurface.withOpacity(navItemUnselectedOpacity),
                      ),
                      selectedIcon: Icon(item.selectedIcon),
                      label: item.label,
                    ),
                  )
                  .toList(),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: (value) {
                setState(() {
                  _currentPageIndex = value;
                });
              },
              selectedIndex: _currentPageIndex,
            ),
            body: Column(
              children: [
                Header(
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      print("TODO"); // TODO: show settings
                    },
                  ),
                  title: widget.navigationItems[_currentPageIndex].label,
                ),
                Expanded(
                  child: widget.navigationItems[_currentPageIndex].page,
                )
              ],
            ),
          );
        } else {
          // NavigationRail for wide devices
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  // set the elevation to match the NavigationBar elevation
                  backgroundColor: ElevationOverlay.colorWithOverlay(
                    colorScheme.surface,
                    colorScheme.primary,
                    3.0,
                  ),
                  leading: NavigationRailMenuButton(
                    onPressed: () {
                      print("TODO"); // TODO: show settings
                    },
                  ),
                  destinations: widget.navigationItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.unselectedIcon),
                          selectedIcon: Icon(item.selectedIcon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                  elevation: 3.0,
                  extended: constraints.maxWidth >= (minContentWidth + extendedSidebarWidth),
                  minExtendedWidth: extendedSidebarWidth,
                  onDestinationSelected: (value) {
                    setState(() {
                      _currentPageIndex = value;
                    });
                  },
                  unselectedLabelTextStyle: navItemBaseTextStyle.copyWith(
                    color: colorScheme.onSurface.withOpacity(navItemUnselectedOpacity),
                  ),
                  selectedLabelTextStyle: navItemBaseTextStyle,
                  unselectedIconTheme: iconTheme.copyWith(opacity: navItemUnselectedOpacity),
                  selectedIconTheme: iconTheme.copyWith(opacity: 1),
                  selectedIndex: _currentPageIndex,
                ),
              ),
              Expanded(
                child: Scaffold(
                  body: Column(
                    children: [
                      Header(title: widget.navigationItems[_currentPageIndex].label),
                      Expanded(
                        child: widget.navigationItems[_currentPageIndex].page,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
