part of 'model_test.dart';

const _rubCode = 'RUB';
const _usdCode = 'USD';
const _eurCode = 'EUR';

final _initialDebitCurrency = _rub;
final _initialCreditCurrency = _usd;

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
