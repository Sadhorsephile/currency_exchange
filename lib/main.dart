import 'package:currency_exchange/core/data/network/client.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkClient.initCacheOptions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<NetworkClient>(
      create: (_) => NetworkClient(Dio()),
      child: const MaterialApp(
        title: 'Currency Exchange',
        home: MainScreen(),
      ),
    );
  }
}
