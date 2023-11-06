import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/ui/editable_element.dart';
import 'package:ma_flutter/ui/font_awesome_icon.dart';
import 'package:ma_flutter/ui/level_divider.dart';
import 'package:ma_flutter/ui/skeleton.dart';
import 'package:ma_flutter/utility/navigable_page.dart';

class AccountsPage extends NavigablePage {
  const AccountsPage({super.key});

  @override
  String get icon => "building-columns";

  @override
  String get label => "Konten";

  @override
  Widget? getFloatingActionButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < EditableElement.maxDialogContainerWidth) {
      ColorScheme colorScheme = Theme.of(context).colorScheme;
      return EditableElement(
        closedBorderRadius: 16.0,
        closedColor: colorScheme.primaryContainer,
        closedElevation: 2,
        closedBuilder: (context, action) => FloatingActionButton.extended(
          onPressed: action,
          label: Text("Hinzufügen"),
          icon: FontAwesomeIcon(
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
      return null; // display floating action button only on small devices
    }
  }

  @override
  List<Widget> getHeaderTrailing(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < EditableElement.maxDialogContainerWidth) {
      return [];
    } else {
      return [
        EditableElement(
          closedBuilder: (context, action) => TextButton.icon(
            onPressed: action,
            icon: FontAwesomeIcon(
              name: "plus",
              size: 14.0,
              style: Style.regular,
            ),
            label: Text("Hinzufügen"),
          ),
          dialogTitle: "Konto erstellen",
          dialogContent: Container(),
        ),
      ];
    }
  }

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late Future<Map<int, Account>> futureAccounts;

  @override
  void initState() {
    super.initState();
    futureAccounts = Account.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Map<int, Account>>(
        future: futureAccounts,
        builder: (BuildContext context, AsyncSnapshot<Map<int, Account>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return accountsList(snapshot.data!);
          } else {
            return Text('Konten konnten nicht geladen werden');
          }
        },
      ),
    );
  }

  Widget accountsList(Map<int, Account> accounts) {
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
                  leading: FontAwesomeIcon(name: account.icon),
                  mouseCursor: SystemMouseCursors.click,
                  onTap: action,
                ),
                dialogTitle: "Konto bearbeiten",
                dialogContent: Container(),
              ),
              if (index < accounts.length - 1) LevelDivider(level: 1),
            ];
          })
          .expand((widgetList) => widgetList)
          .toList(),
    );
  }
}
