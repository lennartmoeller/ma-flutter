import 'package:flutter/material.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/model/transaction.dart';
import 'package:ma_flutter/pages/accounts_page.dart';
import 'package:ma_flutter/pages/categories_page.dart';
import 'package:ma_flutter/pages/transactions_page.dart';
import 'package:ma_flutter/theme/color_schemes.dart';
import 'package:ma_flutter/ui/navigation_item.dart';
import 'package:ma_flutter/ui/skeleton.dart';
import 'package:ma_flutter/utility/http_helper.dart';

void main() async {
  // avoids errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();
  // on app start, fetch the data and save it to the database
  final Future<Map<String, dynamic>> response = HttpHelper.get('data');
  final data = await response;
  (data['accounts'] as Map<String, dynamic>).forEach((key, value) {
    Account.fromJson(value).insert();
  });
  (data['categories'] as Map<String, dynamic>).forEach((key, value) {
    Category.fromJson(value).insert();
  });
  (data['transactions'] as Map<String, dynamic>).forEach((key, value) {
    Transaction.fromJson(value).insert();
  });

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haushaltsbuch',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      // TODO: Remove this after debugging
      themeMode: ThemeMode.light,
      home: Skeleton(
        navigationItems: [
          NavigationItem(
            page: TransactionsPage(),
            unselectedIcon: Icons.payments_outlined,
            selectedIcon: Icons.payments,
            label: 'Transaktionen',
          ),
          NavigationItem(
            page: CategoriesPage(),
            unselectedIcon: Icons.category_outlined,
            selectedIcon: Icons.category,
            label: 'Kategorien',
          ),
          NavigationItem(
            page: AccountsPage(),
            unselectedIcon: Icons.account_balance_outlined,
            selectedIcon: Icons.account_balance,
            label: 'Konten',
          ),
        ],
      ),
    );
  }
}
