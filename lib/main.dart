import 'package:flutter/material.dart';

import 'navigation/navigation.dart';
import 'navigation/navigation_item.dart';
import 'pages/first_page.dart';
import 'pages/second_page.dart';
import 'pages/third_page.dart';

void main() => runApp(const FinanceApp());

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haushaltsbuch',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
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
