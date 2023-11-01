import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/model/transaction.dart';
import 'package:ma_flutter/utility/german_date.dart';
import 'package:ma_flutter/utility/money.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<Map<int, Account>> futureAccounts;
  late Future<Map<int, Category>> futureCategories;
  late Future<Map<int, Transaction>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureAccounts = Account.getAll();
    futureCategories = Category.getAll();
    futureTransactions = Transaction.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([futureAccounts, futureCategories, futureTransactions]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return transactionList(
              snapshot.data![0] as Map<int, Account>,
              snapshot.data![1] as Map<int, Category>,
              snapshot.data![2] as Map<int, Transaction>,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Text('Transaktionen konnten nicht geladen werden');
          }
        },
      ),
    );
  }

  Widget transactionList(Map<int, Account> accounts, Map<int, Category> categories,
      Map<int, Transaction> transactions) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    Map<String, List<ListTile>> transactionsGrouped = {};
    for (Transaction transaction in transactions.values) {
      String date = transaction.date.toString();
      var listTile = ListTile(
        title: Text(categories[transaction.category]!.label),
        leading: Icon(Icons.favorite),
        subtitle: transaction.description != null && transaction.description!.isNotEmpty
            ? Text(transaction.description!)
            : null,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(accounts[transaction.account]!.label),
            Text(Money.format(transaction.amount))
          ],
        ),
      );
      // group by date
      if (transactionsGrouped.containsKey(date)) {
        transactionsGrouped[date]!.add(listTile);
      } else {
        transactionsGrouped[date] = [listTile];
      }
    }
    // sort by date
    transactionsGrouped = SplayTreeMap.from(transactionsGrouped, (a, b) => a.compareTo(b));

    return ListView.builder(
      itemCount: transactionsGrouped.length,
      itemBuilder: (BuildContext context, int index) {
        String date = transactionsGrouped.keys.elementAt(index);
        List<ListTile> transactions = transactionsGrouped[date]!;
        return StickyHeader(
          header: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outline.withOpacity(.3)),
              ),
              color: colorScheme.surface,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            width: double.infinity,
            child: Text(
              GermanDate(date).beautifyDate(),
              style: textTheme.bodyMedium,
            ),
          ),
          content: Column(
            children: [
              ...transactions,
              Container(height: 8.0),
            ],
          ),
        );
      },
    );
  }
}