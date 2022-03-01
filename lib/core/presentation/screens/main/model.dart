import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  /// Список доступных валют
  final currencies = ValueNotifier<List<CurrencyDto>>(_mockCurrencies);

  /// Текущая валюта списания
  CurrencyDto get currentDebitCurrency => _currentDebitCurrency;
  /// Текущая валюта зачисления
  CurrencyDto get currentCreditCurrency => _currentCreditCurrency;

  CurrencyDto _currentDebitCurrency = _rub;
  CurrencyDto _currentCreditCurrency = _usd;

  MainScreenModel(ErrorHandler errorHandler)
      : super(errorHandler: errorHandler);

  /// Метод загрузки данных для экрана
  Future<void> loadData() {
    return Future<void>.delayed(const Duration(seconds: 2));
  }

  /// Метод, меняющий текущую валюту зачисления на валюту, имеющую код [currencyCode]
  void switchCreditTo(String currencyCode) {
    try {
      _currentCreditCurrency = currencies.value.firstWhere(
        (e) => e.code == currencyCode,
        orElse: () =>
            throw Exception('There are no currency with code: $currencyCode'),
      );
    } on Exception catch (e) {
      handleError(e);
    }
  }

  /// Метод, меняющий текущую валюту списания на валюту, имеющую код [currencyCode]
  Future<void> switchDebitTo(String currencyCode) async {
    try {
      _currentDebitCurrency = currencies.value.firstWhere(
        (e) => e.code == currencyCode,
        orElse: () =>
            throw Exception('There are no currency with code: $currencyCode'),
      );
      await Future<void>.delayed(const Duration(seconds: 2));
    } on Exception catch (e) {
      handleError(e);
    }
  }

  /// Метод преобразования из валюты списания в валюту зачисления
  double fromDebitToCredit(double debit) {
    return debit * _currentDebitCurrency[_currentCreditCurrency];
  }

  /// Метод преобразования из валюты зачисления в валюту списания
  double fromCreditToDebit(double credit) {
    return credit / _currentDebitCurrency[_currentCreditCurrency];
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
