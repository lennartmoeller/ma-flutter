import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ma_flutter/model/account.dart';
import 'package:ma_flutter/model/category.dart';
import 'package:ma_flutter/model/transaction.dart';
import 'package:ma_flutter/pages/accounts_page.dart';
import 'package:ma_flutter/pages/categories_page.dart';
import 'package:ma_flutter/pages/transactions_page.dart';
import 'package:ma_flutter/ui/skeleton/skeleton.dart';
import 'package:ma_flutter/ui/theme/color_schemes.dart';
import 'package:ma_flutter/util/http_helper.dart';
import 'package:ma_flutter/util/skeleton_config.dart';
import 'package:provider/provider.dart';

void main() async {
  // avoids errors caused by flutter upgrade
  WidgetsFlutterBinding.ensureInitialized();
  // on app start, fetch the data and save it to the database
  final Future<Map<String, dynamic>> response = HttpHelper.get('data');
  final data = await response;
  (data['accounts'] as Map<String, dynamic>).forEach((key, value) {
    Account.fromMap(value).insert();
  });
  (data['categories'] as Map<String, dynamic>).forEach((key, value) {
    Category.fromMap(value).insert();
  });
  (data['transactions'] as Map<String, dynamic>).forEach((key, value) {
    Transaction.fromMap(value).insert();
  });

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    systemSettings();
    GlobalKey<SkeletonState> skeletonKey = GlobalKey();
    return ChangeNotifierProvider(
      create: (context) => SkeletonConfig(),
      child: MaterialApp(
        title: 'Haushaltsbuch',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        // TODO: Remove this after debugging
        themeMode: ThemeMode.light,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('de'),
        ],
        home: Skeleton(
          key: skeletonKey,
          pages: [
            TransactionsPage(skeletonKey: skeletonKey),
            CategoriesPage(skeletonKey: skeletonKey),
            AccountsPage(skeletonKey: skeletonKey),
          ],
        ),
      ),
    );
  }

  void systemSettings() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
