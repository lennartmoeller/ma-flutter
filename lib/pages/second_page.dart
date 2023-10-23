import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the second page',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
