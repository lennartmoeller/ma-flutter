import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/custom/custom_divider.dart';
import 'package:ma_flutter/ui/skeleton.dart';
import 'package:ma_flutter/util/navigable_page.dart';

class CategoriesPage extends NavigablePage {
  CategoriesPage({super.key, required super.skeletonKey});

  @override
  String get icon => "icons";

  @override
  String get title => "Kategorien";

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends NavigablePageState<CategoriesPage, Map<int, Category>> {
  @override
  Future<Map<int, Category>> loadData() {
    return Category.getAll();
  }

  @override
  Widget content(Map<int, Category> categories) {
    List<Category> categoryList = categories.values.toList();
    categoryList.sort((a, b) => a.label.compareTo(b.label));
    return ListView(
      padding: EdgeInsets.only(bottom: Skeleton.pageBottomPadding),
      children: categoryList
          .mapIndexed((index, category) {
            return [
              ListTile(
                title: Text(category.label),
                leading: CustomIcon(name: category.icon),
              ),
              if (index < categories.length - 1) CustomDivider(level: 1),
            ];
          })
          .expand((widgetList) => widgetList)
          .toList(),
    );
  }
}
