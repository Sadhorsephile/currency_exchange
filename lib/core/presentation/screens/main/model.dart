import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/domain/usecases/get_exchange_rates.dart';
import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  /// Список доступных валют
  final currencies = ValueNotifier<List<CurrencyDto>>([]);
  final CurrenciesUseCasesImpl _currenciesUseCases;

  /// Текущая валюта списания
  CurrencyDto get currentDebitCurrency => _currentDebitCurrency;

  /// Текущая валюта зачисления
  CurrencyDto get currentCreditCurrency => _currentCreditCurrency;

  late CurrencyDto _currentDebitCurrency;
  late CurrencyDto _currentCreditCurrency;

  MainScreenModel(
    this._currenciesUseCases,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  void init() {
    _currentDebitCurrency = _currenciesUseCases.prepopulatedDebit;
    _currentCreditCurrency = _currenciesUseCases.prepopulatedCredit;
  }

  /// Метод загрузки данных для экрана
  Future<void> loadData() async {
    try {
      final debitToCreditCurrencies = await _currenciesUseCases
          .getDebitToCreditCurrencies(_currentDebitCurrency.code);
      currencies.value = debitToCreditCurrencies.allCurrencies;
      
      _currentDebitCurrency = debitToCreditCurrencies.debitCurrency;
      _currentCreditCurrency = debitToCreditCurrencies.creditCurrencies
          .getByCode(_currentCreditCurrency.code);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Метод, меняющий текущую валюту зачисления на валюту, имеющую код [currencyCode]
  void switchCreditTo(String currencyCode) {
    try {
      _currentCreditCurrency = currencies.value.getByCode(currencyCode);
    } on Exception catch (e) {
      handleError(e);
    }
  }

  /// Метод, меняющий текущую валюту списания на валюту, имеющую код [currencyCode]
  Future<void> switchDebitTo(String currencyCode) async {
    try {
      _currentDebitCurrency = currencies.value.getByCode(currencyCode);
      await loadData();
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
