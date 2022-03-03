import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/resources/currencies.dart';

/// Адаптер из [CurrencyStaticInfo] в [CurrencyDto]
extension CurrencyDtoAdapter on CurrencyStaticInfo {
  CurrencyDto toCurrencyDto(Map<String, num> exchangeRates) => CurrencyDto(
        code: abbreviation,
        title: currency,
        symbol: symbol,
        codeToValueExchangeRates: exchangeRates,
      );
}

/// Расширение, позволяющее получить общую информацию (название и символ) о валюте по ее коду
extension CurrencyInfoRetriever on List<CurrencyStaticInfo> {
  CurrencyStaticInfo getByCode(String code) {
    return firstWhere(
      (e) => e.abbreviation == code,
      orElse: () => throw Exception('No info about currency with code = $code'),
    );
  }

  List<CurrencyDto> getCurrenciesWithInfo(Iterable<String> codes) =>
      where((e) => codes.contains(e.abbreviation))
          .map(
            (e) => CurrencyDto.nonPrimary(
              code: e.abbreviation,
              title: e.currency,
              symbol: e.symbol,
            ),
          )
          .toList();
}
