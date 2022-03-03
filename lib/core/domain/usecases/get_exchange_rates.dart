import 'package:currency_exchange/core/data/repository/currency.dart';
import 'package:currency_exchange/core/domain/entities/currency.dart';

/// Класс, представляющий набор интеракторов для получения данных о валюте
abstract class CurrenciesUseCases {
  /// Возвращает изначальную валюту списания
  CurrencyDto get prepopulatedDebit;

  /// Возвращает изначальную валюту зачисления
  CurrencyDto get prepopulatedCredit;

  /// Возвращает основную валюту [CurrencyDto], имеющую [CurrencyDto.code] = [code] и список валют,
  /// к которым основная валюта имеет определенная отношение
  Future<DebitToCreditCurrenciesDto> getDebitToCreditCurrencies(
    String code,
  );
}

class CurrenciesUseCasesImpl implements CurrenciesUseCases {
  final CurrencyRepository _currencyRepository;

  @override
  CurrencyDto get prepopulatedCredit => _currencyRepository.prepopulatedCredit;

  @override
  CurrencyDto get prepopulatedDebit => _currencyRepository.prepopulatedDebit;

  CurrenciesUseCasesImpl(this._currencyRepository);

  @override
  Future<DebitToCreditCurrenciesDto> getDebitToCreditCurrencies(
    String code,
  ) async {
    return _currencyRepository.getDebitToCreditCurrencies(code);
  }
}
