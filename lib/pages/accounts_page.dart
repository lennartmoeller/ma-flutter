import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/ui/custom/custom_divider.dart';
import 'package:ma_flutter/ui/custom/custom_icon.dart';
import 'package:ma_flutter/ui/form/create_element_floating_action_button.dart';
import 'package:ma_flutter/ui/form/create_element_text_button.dart';
import 'package:ma_flutter/ui/form/custom_form.dart';
import 'package:ma_flutter/ui/form/editable_element.dart';
import 'package:ma_flutter/ui/form/inputs/euro_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/icon_form_input.dart';
import 'package:ma_flutter/ui/form/inputs/text_form_input.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
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
  final _formKey = GlobalKey<CustomFormState>();

  @override
  Future<Map<int, Account>> loadData() {
    return Account.getAll();
  }

  @override
  Widget? get floatingActionButton {
    return MediaQuery.of(context).size.width < EditableElement.maxDialogContainerWidth
        ? CreateElementFloatingActionButton(
            form: _getForm(),
            formKey: _formKey,
            dialogTitle: "Konto erstellen",
            onSave: (values) => _onSave(values: values),
          )
        : null;
  }

  @override
  List<Widget> get headerTrailing {
    return MediaQuery.of(context).size.width >= EditableElement.maxDialogContainerWidth
        ? [
            CreateElementTextButton(
              form: _getForm(),
              formKey: _formKey,
              dialogTitle: "Konto erstellen",
              onSave: (values) => _onSave(values: values),
            )
          ]
        : [];
  }

  @override
  Widget content() {
    List<Account> accountList = data.values.toList();
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
                form: _getForm(account: account),
                formKey: _formKey,
                onSave: (values) => _onSave(account: account, values: values),
              ),
              if (index < accountList.length - 1) CustomDivider(level: 1),
            ];
          })
          .expand((widgetList) => widgetList)
          .toList(),
    );
  }

  Widget _getForm({Account? account}) {
    return CustomForm(
      key: _formKey,
      formBuilder: () => Column(
        children: [
          TextFormInput(
            id: "label",
            formKey: _formKey,
            label: "Bezeichnung",
            initial: account?.label ?? "",
            required: true,
          ),
          EuroFormInput(
            id: "start_balance",
            formKey: _formKey,
            label: "Startbetrag",
            initial: account?.startBalance ?? 0,
          ),
          IconFormInput(
            id: "icon",
            formKey: _formKey,
            label: "Icon-Name",
            initial: account?.icon ?? "",
          ),
        ],
      ),
    );
  }

  bool _onSave({Account? account, required Map<String, dynamic> values}) {
    // TODO: Make API request, get ID...
    if (account == null) {
      account = Account.fromMap({'id': 100, ...values});
      account.insert();
    } else {
      account.updateFromMap(values);
      account.update();
    }
    setState(() {
      data[account!.id] = account;
    });
    return true;
  }
}
