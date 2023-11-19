import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/model/transaction.dart';
import 'package:ma_flutter/ui/custom/custom_divider.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/create_element_floating_action_button.dart';
import 'package:ma_flutter/ui/form/create_element_text_button.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/editable_element.dart';
import 'package:ma_flutter/ui/form/inputs/date_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/dropdown_selector_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/euro_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/image_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/text_form_input.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
import 'package:ma_flutter/util/euro.dart';
import 'package:ma_flutter/util/german_date.dart';
import 'package:ma_flutter/util/http_helper.dart';
import 'package:ma_flutter/util/navigable_page.dart';
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
  final _formKey = GlobalKey<CustomFormState>();

  @override
  Future<List<dynamic>> loadData() {
    return Future.wait([
      Account.getAll(),
      Category.getAll(),
      Transaction.getAll(),
    ]);
  }

  @override
  Widget? get floatingActionButton {
    return MediaQuery.of(context).size.width < EditableElement.maxDialogContainerWidth
        ? CreateElementFloatingActionButton(
            formBuilder: () => _getForm(),
            formKey: _formKey,
            dialogTitle: "Transaktion erstellen",
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
              dialogTitle: "Transaktion erstellen",
              onSave: (values) => _onSave(values: values),
            )
          ]
        : [];
  }

  @override
  Widget content() {
    var accounts = data[0] as Map<int, Account>;
    var categories = data[1] as Map<int, Category>;
    var transactions = data[2] as Map<int, Transaction>;

    // group transactions by date, then sort groups by date
    var groupedTransactions = SplayTreeMap.from(
      groupBy<Transaction, String>(transactions.values, (t) => t.date.toString()),
    );

    return ListView.builder(
      padding: EdgeInsets.only(bottom: Skeleton.pageBottomPadding),
      itemCount: groupedTransactions.length,
      itemBuilder: (BuildContext context, int index) {
        String date = groupedTransactions.keys.elementAt(index);
        List<Transaction> transactions = groupedTransactions[date]!;
        return StickyHeader(
          header: Container(
            color: SkeletonState.colorScheme.surface,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  child: Text(
                    GermanDate(date).beautifyDate(),
                    style: SkeletonState.textTheme.bodyMedium,
                  ),
                ),
                CustomDivider(level: 0),
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
                        height: 64,
                        // size of ListTile with title and subtitle
                        alignment: Alignment.center,
                        child: EditableElement(
                          closedBuilder: (context, action) => ListTile(
                            title: Text(category.label),
                            leading: CustomIcon(name: category.icon),
                            subtitle: transaction.description != null &&
                                    transaction.description!.isNotEmpty
                                ? Text(transaction.description!)
                                : null,
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(account.label), Text(Euro.toStr(transaction.amount))],
                            ),
                            mouseCursor: SystemMouseCursors.click,
                            onTap: action,
                          ),
                          dialogTitle: "Transaktion bearbeiten",
                          formBuilder: () => _getForm(transaction: transaction),
                          formKey: _formKey,
                          onSave: (values) => _onSave(transaction: transaction, values: values),
                        ),
                      ),
                      if (index < transactions.length - 1) CustomDivider(level: 1),
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

  Widget _getForm({Transaction? transaction}) {
    var accountOptions = Map.fromEntries((data[0] as Map<int, Account>).entries.toList()
          ..sort((a, b) => a.value.label.compareTo(b.value.label)))
        .map((k, v) => MapEntry(k, v.label));
    var categoryOptions = Map.fromEntries((data[1] as Map<int, Category>).entries.toList()
          ..sort((a, b) => a.value.label.compareTo(b.value.label)))
        .map((k, v) => MapEntry(k, v.label));
    return CustomForm(
      key: _formKey,
      formBuilder: () => Column(
        children: [
          DateFormInput(
            formKey: _formKey,
            id: "date",
            iconName: "calendar-days",
            initial: transaction == null ? null : GermanDate(transaction.date),
            label: "Datum",
            required: true,
          ),
          DropdownSelectorFormInput(
            formKey: _formKey,
            id: "account",
            iconName: "building-columns",
            initial: transaction?.account,
            options: accountOptions,
            label: "Konto",
            required: true,
          ),
          DropdownSelectorFormInput(
            formKey: _formKey,
            id: "category",
            iconName: "icons",
            initial: transaction?.category,
            options: categoryOptions,
            label: "Kategorie",
            required: true,
          ),
          TextFormInput(
            id: "description",
            formKey: _formKey,
            label: "Beschreibung",
            initial: transaction?.description ?? "",
            required: false,
          ),
          EuroFormInput(
            id: "amount",
            formKey: _formKey,
            label: "Betrag",
            initial: transaction?.amount ?? 0,
          ),
          ImageFormInput(
            id: "receipt",
            formKey: _formKey,
            initial: transaction?.receipt,
            buttonText: "Beleg hinzufügen",
          ),
        ],
      ),
    );
  }

  Future<bool> _onSave({Transaction? transaction, required Map<String, dynamic> values}) async {
    if (transaction != null) {
      values["id"] = transaction.id;
    }
    Map<String, dynamic> response = await HttpHelper.put("transaction", values);
    if (transaction == null) {
      transaction = Transaction.fromMap({'id': response["id"], ...values});
      transaction.insert();
    } else {
      transaction.updateFromMap(values);
      transaction.update();
    }
    setState(() {
      data[2][transaction!.id] = transaction;
    });
    return true;
  }
}
