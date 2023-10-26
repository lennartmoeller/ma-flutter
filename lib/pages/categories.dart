import 'package:finances_flutter/model/category.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<Map<int, Category>> futureAccounts;

  @override
  void initState() {
    super.initState();
    futureAccounts = Category.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Map<int, Category>>(
        future: futureAccounts,
        builder:
            (BuildContext context, AsyncSnapshot<Map<int, Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text(
                'Kategorien konnten nicht geladen werden: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value.label),
                );
              }).toList(),
            );
          } else {
            return Text('Kategorien konnten nicht geladen werden');
          }
        },
      ),
    );
  }
}
