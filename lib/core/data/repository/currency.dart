import 'package:currency_exchange/core/data/adapter/currency.dart';
import 'package:currency_exchange/core/data/network/models/currency.dart';
import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/resources/currencies.dart';

/// Репозиторий, предоставляющий доступ к списку доступных валют
abstract class CurrencyRepository {
  /// Возвращает изначальную валюту зачисления
  CurrencyDto get prepopulatedCredit;

  /// Возвращает изначальную валюту списания
  CurrencyDto get prepopulatedDebit;

  /// Возвращает основную валюту [CurrencyDto], имеющую [CurrencyDto.code] = [code] и список валют,
  /// к которым основная валюта имеет определенная отношение
  Future<DebitToCreditCurrenciesDto> getDebitToCreditCurrencies(
    String code,
  );
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  @override
  CurrencyDto get prepopulatedCredit => CurrencyDto.fromCodeAndSymbol(
        _usdCode,
        CurrenciesStaticInfo.list.getSymbolByCode(_usdCode),
      );

  @override
  CurrencyDto get prepopulatedDebit => CurrencyDto.fromCodeAndSymbol(
        _rubCode,
        CurrenciesStaticInfo.list.getSymbolByCode(_rubCode),
      );

  @override
  Future<DebitToCreditCurrenciesDto> getDebitToCreditCurrencies(
    String code,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final debitStaticInfo = CurrenciesStaticInfo.list.getByCode(code);

    final debit =
        debitStaticInfo.toCurrencyDto(_mockCurrencyFromNetwork.exchangeRates);

    final credits = CurrenciesStaticInfo.list
        .getCurrenciesWithInfo(_mockCurrencyFromNetwork.exchangeRates.keys);

    return DebitToCreditCurrenciesDto(debit, credits);
  }
}

final _mockCurrencyFromNetwork = CurrencyNetworkDto(
  'RUB',
  {
    'USD': 100,
    'EUR': 200,
    'SYP': 0.2,
  },
);

const _rubCode = 'RUB';
const _usdCode = 'USD';
