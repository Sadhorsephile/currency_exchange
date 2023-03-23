import 'dart:convert';

import 'package:flutter/services.dart';

/// Расширение, позволяющее получить символ валюты по ее коду
extension SymbolByCodeRetriever on List<CurrencyStaticInfo> {
  String getSymbolByCode(String code) {
    final index = indexWhere((e) => e.abbreviation == code);

    return index == -1 ? '' : this[index].symbol;
  }
}

/// Класс, предоставляющую неизменную информацию о всех доступных валютах
class CurrenciesStaticInfo {
  static const _assetPath = 'assets/json/currencies.json';

  static late List<CurrencyStaticInfo> list;

  /// Метод, инициирующий загрузку данных из json-ассета. Должен вызываться перед стартом приложения
  static Future<void> loadFromJson() async {
    final rawData = await rootBundle.loadString(_assetPath);
    final jsonData =
        List<Map<String, dynamic>>.from(json.decode(rawData) as List<dynamic>);

    list = List.from(jsonData.map<dynamic>(CurrencyStaticInfo.fromMap));
  }
}

/// Дата-класс, содержащий неизменную информацию о валюте
class CurrencyStaticInfo {
  final String currency;
  final String abbreviation;
  final String symbol;

  const CurrencyStaticInfo({
    required this.currency,
    required this.abbreviation,
    required this.symbol,
  });

  factory CurrencyStaticInfo.fromJson(String source) =>
      CurrencyStaticInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  factory CurrencyStaticInfo.fromMap(Map<String, dynamic> map) {
    return CurrencyStaticInfo(
      currency: map['currency'] as String,
      abbreviation: map['abbreviation'] as String,
      symbol: map['symbol'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currency': currency,
      'abbreviation': abbreviation,
      'symbol': symbol,
    };
  }

  String toJson() => json.encode(toMap());
}
