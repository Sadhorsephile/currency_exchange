/// Дата-класс, содержащий информацию о валюте и ее отношении к 
/// другим валютам
class CurrencyDto {
  final String code;
  final String title;
  final String symbol;
  final Map<String, double> codeToValueExchangeRates;

  CurrencyDto({
    required this.code,
    required this.title,
    required this.symbol,
    required this.codeToValueExchangeRates,
  });

  double operator [](CurrencyDto anotherCurrency) {
    if (!codeToValueExchangeRates.containsKey(anotherCurrency.code)) {
      throw Exception('No currency with code: ${anotherCurrency.code}');
    }
    return codeToValueExchangeRates[anotherCurrency.code]!;
  }
}
