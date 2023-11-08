import 'package:flutter/material.dart';

class SkeletonConfig extends ChangeNotifier {
  static const int _defaultPageIndex = 0;
  static const String _defaultTitle = "";
  static const String? _defaultSubtitle = null;
  static const Widget? _defaultFab = null;
  static const List<Widget> _defaultHeaderLeading = [];
  static const List<Widget> _defaultHeaderTrailing = [];

  int _pageIndex = _defaultPageIndex;
  String _title = _defaultTitle;
  String? _subtitle = _defaultSubtitle;
  Widget? _fab = _defaultFab;
  List<Widget> _headerLeading = _defaultHeaderLeading;
  List<Widget> _headerTrailing = _defaultHeaderTrailing;

  int get pageIndex => _pageIndex;
  String get title => _title;
  String? get subtitle => _subtitle;
  Widget? get fab => _fab;
  List<Widget> get headerLeading => _headerLeading;
  List<Widget> get headerTrailing => _headerTrailing;

  set pageIndex(int? value) {
    _pageIndex = value ?? _defaultPageIndex;
    notifyListeners();
  }

  set title(String? value) {
    _title = value ?? _defaultTitle;
    notifyListeners();
  }

  set subtitle(String? value) {
    _subtitle = value ?? _defaultSubtitle;
    notifyListeners();
  }

  set fab(Widget? value) {
    _fab = value ?? _defaultFab;
    notifyListeners();
  }

  set headerLeading(List<Widget>? value) {
    _headerLeading = _defaultHeaderLeading;
    notifyListeners();
  }

  set headerTrailing(List<Widget>? value) {
    _headerTrailing = value ?? _defaultHeaderTrailing;
    notifyListeners();
  }

  void switchPage(int pageIndex) {
    if (_pageIndex == pageIndex) return; // do nothing if no page change
    _pageIndex = pageIndex;
    _title = _defaultTitle;
    _subtitle = _defaultSubtitle;
    _fab = _defaultFab;
    _headerLeading = _defaultHeaderLeading;
    _headerTrailing = _defaultHeaderTrailing;
    notifyListeners();
  }
}
