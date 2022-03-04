import 'package:currency_exchange/core/domain/entities/currency.dart';

/// Класс, представляющий набор интеракторов для получения данных о валюте
abstract class CurrenciesUseCases {
  CurrencyDto get prepopulatedDebit;

  /// Возвращает изначальную валюту зачисления
  CurrencyDto get prepopulatedCredit;

  /// Возвращает основную валюту [CurrencyDto], имеющую [CurrencyDto.code] = [code] и список валют,
  /// к которым основная валюта имеет определенная отношение
  Future<DebitToCreditCurrenciesContainer> getDebitToCreditCurrencies(
    String code,
  );
}

class CurrenciesUseCasesImpl implements CurrenciesUseCases {
  @override
  CurrencyDto get prepopulatedCredit => CurrencyDto.fromCode(_usdCode);

  @override
  CurrencyDto get prepopulatedDebit => CurrencyDto.fromCode(_rubCode);

  @override
  Future<DebitToCreditCurrenciesContainer> getDebitToCreditCurrencies(
    String code,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return DebitToCreditCurrenciesContainer(_rub, _mockCurrencies);
  }
}

const _rubCode = 'RUB';
const _usdCode = 'USD';
const _eurCode = 'EUR';

final _rub = CurrencyDto(
  title: 'Rub',
  symbol: '₽',
  code: _rubCode,
  codeToValueExchangeRates: {
    _usdCode: 1 / 120,
    _eurCode: 1 / 200,
  },
);

final _usd = CurrencyDto(
  title: 'Usd',
  symbol: r'$',
  code: _usdCode,
  codeToValueExchangeRates: {
    _rubCode: 120,
    _eurCode: 120 / 200,
  },
);

final _eur = CurrencyDto(
  title: 'Eur',
  symbol: '€',
  code: _eurCode,
  codeToValueExchangeRates: {
    _rubCode: 200,
    _usdCode: 200 / 120,
  },
);

final _mockCurrencies = [
  _rub,
  _usd,
  _eur,
];
