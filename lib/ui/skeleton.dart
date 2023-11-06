import 'package:flutter/material.dart';
import 'package:ma_flutter/ui/column_with_separator.dart';
import 'package:ma_flutter/ui/font_awesome_icon.dart';
import 'package:ma_flutter/ui/navigation_rail_menu_button.dart';
import 'package:ma_flutter/utility/navigable_page.dart';

class Skeleton extends StatefulWidget {
  static const double headerHeight = 100.0;
  static const double pageBottomPadding = 14.0;

  final List<NavigablePage> pages;

  const Skeleton({super.key, required this.pages});

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
          _getHeader(
              leading: [
                IconButton(
                  icon: FontAwesomeIcon(name: "bars"),
                  onPressed: _openSettings,
                ),
                ...widget.pages[_currentPageIndex].getHeaderLeading(context),
              ],
              title: widget.pages[_currentPageIndex].label,
              trailing: widget.pages[_currentPageIndex].getHeaderTrailing(context)),
          Expanded(child: widget.pages[_currentPageIndex])
        ],
      ),
      floatingActionButton: widget.pages[_currentPageIndex].getFloatingActionButton(context),
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
                _getHeader(
                  leading: widget.pages[_currentPageIndex].getHeaderLeading(context),
                  title: widget.pages[_currentPageIndex].label,
                  trailing: widget.pages[_currentPageIndex].getHeaderTrailing(context),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: widget.pages[_currentPageIndex],
                  ),
                )
              ],
            ),
            floatingActionButton: widget.pages[_currentPageIndex].getFloatingActionButton(context),
          ),
        ),
      ],
    );
  }

  Widget _getHeader({
    List<Widget>? leading,
    String? title,
    String? subtitle,
    List<Widget>? trailing,
  }) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    const padding = (Skeleton.headerHeight - 52.0) / 4;

    return Container(
      color: colorScheme.surface,
      height: Skeleton.headerHeight,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Row(
          children: [
            RowWithSeparator(
              separator: SizedBox(width: 16.0),
              children: leading ?? [],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) Text(title, style: textTheme.titleLarge),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
                      ),
                  ],
                ),
              ),
            ),
            RowWithSeparator(
              separator: SizedBox(width: 16.0),
              children: trailing ?? [],
            ),
          ],
        ),
      ),
    );
  }

  List<NavigationDestination> _getNavigationBarDestinations() {
    return widget.pages.map((item) {
      return NavigationDestination(
        icon: FontAwesomeIcon(
          name: item.icon,
          opacity: _navItemUnselectedOpacity,
          style: Style.regular,
        ),
        selectedIcon: FontAwesomeIcon(name: item.icon, style: Style.solid),
        label: item.label,
      );
    }).toList();
  }

  List<NavigationRailDestination> _getNavigationRailDestinations() {
    return widget.pages.map((item) {
      return NavigationRailDestination(
        icon: FontAwesomeIcon(name: item.icon, style: Style.regular),
        selectedIcon: FontAwesomeIcon(name: item.icon, style: Style.solid),
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
