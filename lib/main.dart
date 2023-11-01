import 'package:finances_flutter/model/account.dart';
import 'package:finances_flutter/model/category.dart';
import 'package:finances_flutter/model/transaction.dart';
import 'package:finances_flutter/pages/accounts.dart';
import 'package:finances_flutter/pages/categories.dart';
import 'package:finances_flutter/pages/transactions.dart';
import 'package:finances_flutter/theme/color_schemes.dart';
import 'package:finances_flutter/utility/http/http_helper.dart';
import 'package:finances_flutter/utility/navigation/navigation.dart';
import 'package:finances_flutter/utility/navigation/navigation_item.dart';
import 'package:flutter/material.dart';

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
      themeMode: ThemeMode.light,
      // DEBUG: light and dark theme
      home: const Navigation(
        navigationItems: [
          NavigationItem(
            page: CategoriesPage(),
            unselectedIcon: Icons.check_outlined,
            selectedIcon: Icons.check,
            label: 'Kategorien',
          ),
          NavigationItem(
            page: AccountsPage(),
            unselectedIcon: Icons.check_outlined,
            selectedIcon: Icons.check,
            label: 'Konten',
          ),
          NavigationItem(
            page: TransactionsPage(),
            unselectedIcon: Icons.check_outlined,
            selectedIcon: Icons.check,
            label: 'Transaktionen',
          )
        ],
      ),
    );
  }
}
