import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/ui/font_awesome_icon.dart';
import 'package:ma_flutter/ui/level_divider.dart';
import 'package:ma_flutter/ui/skeleton.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

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
              ListTile(
                title: Text(account.label),
                leading: FontAwesomeIcon(name: account.icon),
              ),
              if (index < accounts.length - 1) LevelDivider(level: 1),
            ];
          })
          .expand((widgetList) => widgetList)
          .toList(),
    );
  }
}
