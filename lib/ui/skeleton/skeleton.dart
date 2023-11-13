import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/skeleton/navigation_rail_menu_button.dart';
import 'package:ma_flutter/ui/util/row_with_separator.dart';
import 'package:ma_flutter/util/navigable_page.dart';
import 'package:ma_flutter/util/skeleton_config.dart';
import 'package:provider/provider.dart';

class Skeleton extends StatefulWidget {
  static const double headerHeight = 100.0;
  static const double pageBottomPadding = 14.0;

  final List<NavigablePage> pages;

  const Skeleton({super.key, required this.pages});

  @override
  State<Skeleton> createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> {
  static const double _compressedSidebarWidth = 80.0;
  static const double _extendedSidebarWidth = 220.0;
  static const double _minContentWidth = 500.0;
  static const double _navItemUnselectedOpacity = 0.55;
  static late double statusBarHeight;
  static late ColorScheme colorScheme;
  static late TextTheme textTheme;
  static late IconThemeData iconTheme;

  late SkeletonConfig config;

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    textTheme = Theme.of(context).textTheme;
    iconTheme = Theme.of(context).iconTheme;
    config = Provider.of<SkeletonConfig>(context);
    statusBarHeight = MediaQuery.of(context).viewPadding.top;

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
        onDestinationSelected: config.switchPage,
        selectedIndex: config.pageIndex,
      ),
      body: Column(
        children: [
          _getHeader(menuItem: true),
          Expanded(child: widget.pages[config.pageIndex]),
        ],
      ),
      floatingActionButton: config.fab,
    );
  }

  Widget _buildForWideDevices(double deviceWidth) {
    TextStyle navItemBaseTextStyle = textTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 13,
      letterSpacing: 0.2,
    );

    return Row(
      children: [
        SafeArea(
          child: NavigationRail(
            backgroundColor: ElevationOverlay.colorWithOverlay(
              colorScheme.surface,
              colorScheme.primary,
              3.0,
            ),
            leading: NavigationRailMenuButton(onPressed: _openSettings),
            destinations: _getNavigationRailDestinations(),
            elevation: 3.0,
            extended: deviceWidth >= (_minContentWidth + _extendedSidebarWidth),
            minExtendedWidth: _extendedSidebarWidth,
            onDestinationSelected: config.switchPage,
            unselectedLabelTextStyle: navItemBaseTextStyle.copyWith(
              color: colorScheme.onSurface.withOpacity(_navItemUnselectedOpacity),
            ),
            selectedLabelTextStyle: navItemBaseTextStyle,
            unselectedIconTheme: iconTheme.copyWith(opacity: _navItemUnselectedOpacity),
            selectedIconTheme: iconTheme,
            selectedIndex: config.pageIndex,
          ),
        ),
        Expanded(
          child: Scaffold(
            body: Column(
              children: [
                _getHeader(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: widget.pages[config.pageIndex],
                  ),
                )
              ],
            ),
            floatingActionButton: config.fab,
          ),
        ),
      ],
    );
  }

  Widget _getHeader({bool menuItem = false}) {
    const double padding = (Skeleton.headerHeight - 52.0) / 4;
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      color: colorScheme.surface,
      height: Skeleton.headerHeight + statusBarHeight,
      width: double.infinity,
      padding: EdgeInsets.only(top: statusBarHeight, left: padding * 2, right: padding * 2),
      child: RowWithSeparator(
        separator: SizedBox(width: padding),
        children: [
          if (menuItem)
            IconButton(
              icon: CustomIcon(name: "bars"),
              onPressed: _openSettings,
            ),
          ...config.headerLeading,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(config.title, style: textTheme.titleLarge),
                if (config.subtitle != null)
                  Text(
                    config.subtitle!,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
                  ),
              ],
            ),
          ),
          ...config.headerTrailing,
        ],
      ),
    );
  }

  List<NavigationDestination> _getNavigationBarDestinations() {
    return widget.pages.map((item) {
      return NavigationDestination(
        icon: CustomIcon(
          name: item.icon,
          opacity: _navItemUnselectedOpacity,
          style: Style.regular,
        ),
        selectedIcon: CustomIcon(name: item.icon, style: Style.solid),
        label: item.title,
      );
    }).toList();
  }

  List<NavigationRailDestination> _getNavigationRailDestinations() {
    return widget.pages.map((item) {
      return NavigationRailDestination(
        icon: CustomIcon(name: item.icon, style: Style.regular),
        selectedIcon: CustomIcon(name: item.icon, style: Style.solid),
        label: Text(item.title),
      );
    }).toList();
  }

  void _openSettings() {
    print("TODO: Implement"); // TODO: Implement
  }
}
