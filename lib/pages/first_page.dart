import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the first page',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
