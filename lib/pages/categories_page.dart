import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/ui/custom/custom_divider.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/create_element_floating_action_button.dart';
import 'package:ma_flutter/ui/form/create_element_text_button.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/editable_element.dart';
import 'package:ma_flutter/ui/form/inputs/dropdown_selector_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/icon_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/text_form_input.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
import 'package:ma_flutter/ui/util/column_with_separator.dart';
import 'package:ma_flutter/util/http_helper.dart';
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
  final _formKey = GlobalKey<CustomFormState>();

  @override
  Future<Map<int, Category>> loadData() {
    return Category.getAll();
  }

  @override
  Widget? get floatingActionButton {
    return MediaQuery.of(context).size.width < EditableElement.maxDialogContainerWidth
        ? CreateElementFloatingActionButton(
            formBuilder: () => _getForm(),
            formKey: _formKey,
            dialogTitle: "Kategorie erstellen",
            onSave: (values) => _onSave(values: values),
          )
        : null;
  }

  @override
  List<Widget> get headerTrailing {
    return MediaQuery.of(context).size.width >= EditableElement.maxDialogContainerWidth
        ? [
            CreateElementTextButton(
              formBuilder: () => _getForm(),
              formKey: _formKey,
              dialogTitle: "Kategorie erstellen",
              onSave: (values) => _onSave(values: values),
            )
          ]
        : [];
  }

  @override
  Widget content() {
    List<Category> categoryList = data.values.toList();
    categoryList.sort((a, b) => a.label.compareTo(b.label));
    return ListView(
      padding: EdgeInsets.only(bottom: SkeletonState.pageBottomPadding),
      children: categoryList
          .mapIndexed((index, category) {
            return [
              EditableElement(
                closedBuilder: (context, action) => ListTile(
                  title: Text(category.label),
                  leading: CustomIcon(name: category.icon, style: Style.regular),
                  mouseCursor: SystemMouseCursors.click,
                  onTap: action,
                ),
                dialogTitle: "Kategorie bearbeiten",
                formBuilder: () => _getForm(category: category),
                formKey: _formKey,
                onSave: (values) => _onSave(category: category, values: values),
              ),
              if (index < categoryList.length - 1) CustomDivider(level: 1),
            ];
          })
          .expand((widgetList) => widgetList)
          .toList(),
    );
  }

  Widget _getForm({Category? category}) {
    return CustomForm(
      key: _formKey,
      formBuilder: () => ColumnWithSeparator(
        separator: SizedBox(height: 8.0),
        children: [
          DropdownSelectorFormInput(
            formKey: _formKey,
            id: "type",
            iconName: "tag",
            initial: category?.type ?? 1,
            options: <int, String>{1: "Ausgaben", 2: "Einnahmen"},
            label: "Art",
          ),
          TextFormInput(
            id: "label",
            formKey: _formKey,
            label: "Bezeichnung",
            initial: category?.label ?? "",
            required: true,
          ),
          IconFormInput(
            id: "icon",
            formKey: _formKey,
            label: "Icon-Name",
            initial: category?.icon ?? "",
          ),
        ],
      ),
    );
  }

  Future<bool> _onSave({Category? category, required Map<String, dynamic> values}) async {
    if (category != null) {
      values["id"] = category.id;
    }
    Map<String, dynamic> response = await HttpHelper.put("category", values);
    if (category == null) {
      category = Category.fromMap({'id': response["id"], ...values});
      category.insert();
    } else {
      category.updateFromMap(values);
      category.update();
    }
    setState(() {
      data[category!.id] = category;
    });
    return true;
  }
}
