import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is the third page',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
