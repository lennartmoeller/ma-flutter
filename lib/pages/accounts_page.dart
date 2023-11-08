import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/ui/editable_element.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/custom/custom_divider.dart';
import 'package:ma_flutter/ui/skeleton.dart';
import 'package:ma_flutter/util/navigable_page.dart';

class AccountsPage extends NavigablePage {
  AccountsPage({super.key, required super.skeletonKey});

  @override
  String get icon => "building-columns";

  @override
  String get title => "Konten";

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends NavigablePageState<AccountsPage, Map<int, Account>> {
  @override
  Future<Map<int, Account>> loadData() {
    return Account.getAll();
  }

  @override
  Widget? get floatingActionButton {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < EditableElement.maxDialogContainerWidth) {
      ColorScheme colorScheme = Theme.of(context).colorScheme;
      return EditableElement(
        closedBorderRadius: 16.0,
        // fab default border radius
        closedColor: colorScheme.primaryContainer,
        // fab default background color
        openedColor: colorScheme.surface,
        closedElevation: 3,
        // fab default elevation
        closedBuilder: (context, action) => FloatingActionButton.extended(
          // remove elevation because elevation is set by EditableElement
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          onPressed: action,
          label: Text("Hinzufügen"),
          icon: CustomIcon(
            name: "plus",
            size: 18.0,
            style: Style.regular,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        dialogTitle: "Konto erstellen",
        dialogContent: Container(),
      );
    } else {
      return null;
    }
  }

  @override
  List<Widget> get headerTrailing {
    List<Widget> output = [];
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= EditableElement.maxDialogContainerWidth) {
      output.add(
        EditableElement(
          closedBuilder: (context, action) => TextButton.icon(
            onPressed: action,
            icon: CustomIcon(
              name: "plus",
              size: 14.0,
              style: Style.regular,
            ),
            label: Text("Hinzufügen"),
          ),
          dialogTitle: "Konto erstellen",
          dialogContent: Container(),
        ),
      );
    }
    return output;
  }

  @override
  Widget content(Map<int, Account> accounts) {
    List<Account> accountList = accounts.values.toList();
    accountList.sort((a, b) => a.label.compareTo(b.label));
    return ListView(
      padding: EdgeInsets.only(bottom: Skeleton.pageBottomPadding),
      children: accountList
          .mapIndexed((index, account) {
            return [
              EditableElement(
                closedBuilder: (context, action) => ListTile(
                  title: Text(account.label),
                  leading: CustomIcon(name: account.icon),
                  mouseCursor: SystemMouseCursors.click,
                  onTap: action,
                ),
                dialogTitle: "Konto bearbeiten",
                dialogContent: Container(),
              ),
              if (index < accounts.length - 1) CustomDivider(level: 1),
            ];
          })
          .expand((widgetList) => widgetList)
          .toList(),
    );
  }
}
