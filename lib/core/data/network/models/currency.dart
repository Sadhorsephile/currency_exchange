import 'dart:convert';

/// Дата-класс валюты, хранящий информацию о коде валюты и ее отношении к другим валютам
class CurrencyNetworkDto {
  final String code;
  final Map<String, double> exchangeRates;

  CurrencyNetworkDto(this.code, this.exchangeRates);

  factory CurrencyNetworkDto.fromJson(String source) =>
      CurrencyNetworkDto.fromMap(
        json.decode(source.toString()) as Map<String, double>,
      );

  factory CurrencyNetworkDto.fromMap(Map<String, dynamic> map) {
    return CurrencyNetworkDto(
      (map['base'] ?? '').toString(),
      Map<String, double>.from(map['rates'] as Map<String, double>),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'base': code,
      'rates': exchangeRates,
    };
  }

  String toJson() => json.encode(toMap());
}
