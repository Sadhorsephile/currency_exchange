import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Currency Exchange',
      home: MainScreen(),
    );
  }
}

