import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:currency_exchange/resources/currencies.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CurrenciesStaticInfo.loadFromJson();
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
