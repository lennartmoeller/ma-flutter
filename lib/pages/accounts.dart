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
        builder:
            (BuildContext context, AsyncSnapshot<Map<int, Account>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
                'Konten konnten nicht geladen werden: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value.label),
                );
              }).toList(),
            );
          } else {
            return Text('Konten konnten nicht geladen werden');
          }
        },
      ),
    );
  }
}
