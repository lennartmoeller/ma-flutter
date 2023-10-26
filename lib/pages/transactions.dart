import 'package:finances_flutter/model/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<Map<int, Transaction>> futureAccounts;

  @override
  void initState() {
    super.initState();
    futureAccounts = Transaction.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Map<int, Transaction>>(
        future: futureAccounts,
        builder: (BuildContext context,
            AsyncSnapshot<Map<int, Transaction>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
                'Transaktionen konnten nicht geladen werden: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value.description),
                );
              }).toList(),
            );
          } else {
            return Text('Transaktionen konnten nicht geladen werden');
          }
        },
      ),
    );
  }
}
