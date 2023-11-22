import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/skeleton/navigation_rail_menu_button.dart';
import 'package:ma_flutter/ui/util/row_with_separator.dart';
import 'package:ma_flutter/util/navigable_page.dart';
import 'package:ma_flutter/util/skeleton_config.dart';
import 'package:provider/provider.dart';

class Skeleton extends StatefulWidget {
  final List<NavigablePage> pages;

  const Skeleton({super.key, required this.pages});

  @override
  State<Skeleton> createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> {
  static const double compressedSidebarWidth = 80.0;
  static const double extendedSidebarWidth = 220.0;
  static const double minContentWidth = 500.0;
  static const double navItemUnselectedOpacity = 0.55;
  static const double navItemSelectedOpacity = 0.8;
  static const headerHeightThinDevices = 80.0;
  static const headerHeightWideDevices = 100.0;
  static const double pageBottomPadding = 14.0;
  static const double contentPadding = 16.0;
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
        if (constraints.maxWidth < (minContentWidth + compressedSidebarWidth)) {
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
          _getHeader(thinDevice: true),
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
            extended: deviceWidth >= (minContentWidth + extendedSidebarWidth),
            minExtendedWidth: extendedSidebarWidth,
            onDestinationSelected: config.switchPage,
            unselectedLabelTextStyle: navItemBaseTextStyle.copyWith(
              color: colorScheme.onSurface.withOpacity(navItemUnselectedOpacity),
            ),
            selectedLabelTextStyle: navItemBaseTextStyle,
            unselectedIconTheme: iconTheme.copyWith(opacity: navItemUnselectedOpacity),
            selectedIconTheme: iconTheme.copyWith(opacity: navItemSelectedOpacity),
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
                    padding: EdgeInsets.symmetric(horizontal: contentPadding),
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

  Widget _getHeader({bool thinDevice = false}) {
    double headerHeight = thinDevice ? headerHeightThinDevices : headerHeightWideDevices;
    double paddingItems = (headerHeight - 52.0) / 4;
    double paddingSides = thinDevice ? paddingItems * 2 : paddingItems + contentPadding;
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      color: colorScheme.surface,
      height: headerHeight + statusBarHeight,
      width: double.infinity,
      padding: EdgeInsets.only(top: statusBarHeight, left: paddingSides, right: paddingSides),
      child: RowWithSeparator(
        separator: SizedBox(width: paddingItems),
        children: [
          if (thinDevice)
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
          opacity: navItemUnselectedOpacity,
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
