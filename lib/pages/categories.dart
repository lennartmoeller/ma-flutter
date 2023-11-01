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
        builder: (BuildContext context, AsyncSnapshot<Map<int, Category>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return categoriesList(snapshot.data!);
          } else {
            return Text('Kategorien konnten nicht geladen werden');
          }
        },
      ),
    );
  }

  Widget categoriesList(Map<int, Category> categories) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return ListView(
      children: categories.values.map((category) {
        return ListTile(
          title: Text(category.label),
          leading: Icon(Icons.favorite),
          shape: Border(
            bottom: BorderSide(color: colorScheme.outline),
          ),
        );
      }).toList(),
    );
  }
}
