import 'package:currency_exchange/core/data/network/client.dart';
import 'package:currency_exchange/core/data/network/service/get_exchange_rates.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:currency_exchange/resources/currencies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args, [GetExchangeRatesApi? api]) async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkClient.initCacheOptions();
  await CurrenciesStaticInfo.loadFromJson();
  runApp(MyApp(api: api));
}

class MyApp extends StatelessWidget {
  final GetExchangeRatesApi? api;

  const MyApp({
    required this.api,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<NetworkClient>(
      create: (_) => NetworkClient(Dio()),
      child: Builder(
        builder: (context) => Provider<GetExchangeRatesApi>(
          create: (context) =>
              api ?? GetExchangeRatesApiImpl(context.read<NetworkClient>()),
          child: const MaterialApp(
            title: 'Currency Exchange',
            home: MainScreen(),
          ),
        ),
      ),
    );
  }
}
