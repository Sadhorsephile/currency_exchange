import 'package:currency_exchange/core/data/adapter/currency.dart';
import 'package:currency_exchange/core/data/network/service/get_exchange_rates.dart';
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
  final GetExchangeRatesApi _getExchangeRatesApi;

  @override
  CurrencyDto get prepopulatedCredit => CurrencyDto.fromCode(_usdCode);

  @override
  CurrencyDto get prepopulatedDebit => CurrencyDto.fromCode(_rubCode);

  CurrencyRepositoryImpl(this._getExchangeRatesApi);

  @override
  Future<DebitToCreditCurrenciesDto> getDebitToCreditCurrencies(
    String code,
  ) async {
    final _currencyWithRates = await _getExchangeRatesApi(code);

    final debitStaticInfo = CurrenciesStaticInfo.list.getByCode(code);

    final debit =
        debitStaticInfo.toCurrencyDto(_currencyWithRates.exchangeRates);

    final credits = CurrenciesStaticInfo.list
        .getCurrenciesWithInfo(_currencyWithRates.exchangeRates.keys);

    return DebitToCreditCurrenciesDto(debit, credits);
  }
}

const _rubCode = 'EUR';
const _usdCode = 'USD';
