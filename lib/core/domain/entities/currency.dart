import 'package:currency_exchange/resources/currencies.dart';

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

  /// Фабрика для создания валюты, не имеющей данных об ее отношении к другим валютам
  factory CurrencyDto.nonPrimary({
    required String code,
    required String title,
    required String symbol,
  }) =>
      CurrencyDto(
        code: code,
        title: title,
        symbol: symbol,
        codeToValueExchangeRates: {},
      );

  /// Фабрика для создания валюты из кода
  factory CurrencyDto.fromCode(String code) => CurrencyDto(
        code: code,
        title: '',
        symbol: CurrenciesStaticInfo.list.getSymbolByCode(code),
        codeToValueExchangeRates: {},
      );

  double operator [](CurrencyDto anotherCurrency) {
    if (!codeToValueExchangeRates.containsKey(anotherCurrency.code)) {
      throw Exception('No currency with code: ${anotherCurrency.code}');
    }
    return codeToValueExchangeRates[anotherCurrency.code]!;
  }
}

/// Дата-класс, содержащий в себе основную валюту и список валют, 
/// к которым она имеет определенное отношение
class DebitToCreditCurrenciesDto {
  final CurrencyDto debitCurrency;
  final List<CurrencyDto> creditCurrencies;

  List<CurrencyDto> get allCurrencies => [debitCurrency, ...creditCurrencies];

  DebitToCreditCurrenciesDto(this.debitCurrency, this.creditCurrencies);
}
