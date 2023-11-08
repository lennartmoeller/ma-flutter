import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/model/transaction.dart';
import 'package:ma_flutter/ui/font_awesome_icon.dart';
import 'package:ma_flutter/ui/level_divider.dart';
import 'package:ma_flutter/ui/skeleton.dart';
import 'package:ma_flutter/utility/german_date.dart';
import 'package:ma_flutter/utility/money.dart';
import 'package:ma_flutter/utility/navigable_page.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionsPage extends NavigablePage {
  TransactionsPage({super.key, required super.skeletonKey});

  @override
  String get icon => "money-bills";

  @override
  String get title => "Transaktionen";

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends NavigablePageState<TransactionsPage, List<dynamic>> {
  @override
  Future<List<dynamic>> loadData() {
    return Future.wait([
      Account.getAll(),
      Category.getAll(),
      Transaction.getAll(),
    ]);
  }

  @override
  Widget content(List<dynamic> data) {
    var accounts = data[0] as Map<int, Account>;
    var categories = data[1] as Map<int, Category>;
    var transactions = data[2] as Map<int, Transaction>;

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    // group transactions by date, then sort groups by date
    var groupedTransactions = SplayTreeMap.from(
        groupBy<Transaction, String>(transactions.values, (t) => t.date.toString()));

    return ListView.builder(
      padding: EdgeInsets.only(bottom: Skeleton.pageBottomPadding),
      itemCount: groupedTransactions.length,
      itemBuilder: (BuildContext context, int index) {
        String date = groupedTransactions.keys.elementAt(index);
        List<Transaction> transactions = groupedTransactions[date]!;
        return StickyHeader(
          header: Container(
            color: colorScheme.surface,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text(
                    GermanDate(date).beautifyDate(),
                    style: textTheme.bodyMedium,
                  ),
                ),
                LevelDivider(level: 0),
              ],
            ),
          ),
          content: Column(
            children: transactions
                .mapIndexed(
                  (index, transaction) {
                    Account account = accounts[transaction.account]!;
                    Category category = categories[transaction.category]!;
                    return [
                      Container(
                        height: 64, // size of ListTile with title and subtitle
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(category.label),
                          leading: FontAwesomeIcon(name: category.icon),
                          subtitle:
                              transaction.description != null && transaction.description!.isNotEmpty
                                  ? Text(transaction.description!)
                                  : null,
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(account.label), Text(Money.format(transaction.amount))],
                          ),
                        ),
                      ),
                      if (index < transactions.length - 1) LevelDivider(level: 1),
                    ];
                  },
                )
                .expand((widgetList) => widgetList)
                .toList(),
          ),
        );
      },
    );
  }
}
