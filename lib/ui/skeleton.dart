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
  static const double _compressedSidebarWidth = 80.0;
  static const double _extendedSidebarWidth = 220.0;
  static const double _minContentWidth = 500.0;
  static const double _navItemUnselectedOpacity = 0.55;

  late ColorScheme _colorScheme;
  late TextTheme _textTheme;
  late IconThemeData _iconTheme;

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    _colorScheme = Theme.of(context).colorScheme;
    _textTheme = Theme.of(context).textTheme;
    _iconTheme = Theme.of(context).iconTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < (_minContentWidth + _compressedSidebarWidth)) {
          return _buildForThinDevices();
        } else {
          return _buildForWideDevices(constraints.maxWidth);
        }
      },
    );
  }

  Widget _buildForThinDevices() {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: _getNavigationBarDestinations(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: _updateCurrentPageIndex,
        selectedIndex: _currentPageIndex,
      ),
      body: Column(
        children: [
          Header(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: _openSettings,
            ),
            title: widget.navigationItems[_currentPageIndex].label,
          ),
          Expanded(
            child: widget.navigationItems[_currentPageIndex].page
          )
        ],
      ),
    );
  }

  Widget _buildForWideDevices(double deviceWidth) {
    TextStyle navItemBaseTextStyle = _textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 13,
      letterSpacing: 0.2,
    );

    return Row(
      children: [
        SafeArea(
          child: NavigationRail(
            backgroundColor: ElevationOverlay.colorWithOverlay(
              _colorScheme.surface,
              _colorScheme.primary,
              3.0,
            ),
            leading: NavigationRailMenuButton(onPressed: _openSettings),
            destinations: _getNavigationRailDestinations(),
            elevation: 3.0,
            extended: deviceWidth >= (_minContentWidth + _extendedSidebarWidth),
            minExtendedWidth: _extendedSidebarWidth,
            onDestinationSelected: _updateCurrentPageIndex,
            unselectedLabelTextStyle: navItemBaseTextStyle.copyWith(
              color: _colorScheme.onSurface.withOpacity(_navItemUnselectedOpacity),
            ),
            selectedLabelTextStyle: navItemBaseTextStyle,
            unselectedIconTheme: _iconTheme.copyWith(opacity: _navItemUnselectedOpacity),
            selectedIconTheme: _iconTheme,
            selectedIndex: _currentPageIndex,
          ),
        ),
        Expanded(
          child: Scaffold(
            body: Column(
              children: [
                Header(title: widget.navigationItems[_currentPageIndex].label),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: widget.navigationItems[_currentPageIndex].page,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<NavigationDestination> _getNavigationBarDestinations() {
    return widget.navigationItems.map((item) {
      return NavigationDestination(
        icon: Icon(
          item.unselectedIcon,
          color: _colorScheme.onSurface.withOpacity(_navItemUnselectedOpacity),
        ),
        selectedIcon: Icon(item.selectedIcon),
        label: item.label,
      );
    }).toList();
  }

  List<NavigationRailDestination> _getNavigationRailDestinations() {
    return widget.navigationItems.map((item) {
      return NavigationRailDestination(
        icon: Icon(item.unselectedIcon),
        selectedIcon: Icon(item.selectedIcon),
        label: Text(item.label),
      );
    }).toList();
  }

  void _updateCurrentPageIndex(int value) {
    setState(() {
      _currentPageIndex = value;
    });
  }

  void _openSettings() {
    print("TODO: Implement"); // TODO: Implement
  }
}
