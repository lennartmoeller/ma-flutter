import 'package:finances_flutter/navigation/navigation.dart';
import 'package:finances_flutter/navigation/navigation_item.dart';
import 'package:finances_flutter/pages/first_page.dart';
import 'package:finances_flutter/pages/second_page.dart';
import 'package:finances_flutter/pages/third_page.dart';
import 'package:finances_flutter/theme/color_schemes.dart';
import 'package:flutter/material.dart';

void main() => runApp(const FinanceApp());

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haushaltsbuch',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.dark, // DEBUG: light and dark theme
      home: const Navigation(
        navigationItems: [
          NavigationItem(
            page: FirstPage(),
            unselectedIcon: Icons.check_outlined,
            selectedIcon: Icons.check,
            label: 'First',
          ),
          NavigationItem(
            page: SecondPage(),
            unselectedIcon: Icons.check_outlined,
            selectedIcon: Icons.check,
            label: 'Second',
          ),
          NavigationItem(
            page: ThirdPage(),
            unselectedIcon: Icons.check_outlined,
            selectedIcon: Icons.check,
            label: 'Third',
          )
        ],
      ),
    );
  }
}
