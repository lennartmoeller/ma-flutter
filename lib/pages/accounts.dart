import 'package:finances_flutter/model/account.dart';
import 'package:flutter/material.dart';

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
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ListView(
      children: accounts.values.map((account) {
        return ListTile(
          title: Text(account.label),
          shape: Border(
            bottom: BorderSide(color: colorScheme.outline),
          ),
        );
      }).toList(),
    );
  }
}
