import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/domain/usecases/get_exchange_rates.dart';
import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:elementary/elementary.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  /// Список доступных валют
  final CurrenciesUseCasesImpl _currenciesUseCases;

  late CurrencyDto _currentDebitCurrency;
  late CurrencyDto _currentCreditCurrency;

  var _currencies = <CurrencyDto>[];

  MainScreenModel(
    this._currenciesUseCases,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  void init() {
    _currentDebitCurrency = getInitialDebit();
    _currentCreditCurrency = getInitialCredit();
  }

  CurrencyDto getInitialDebit() => _currenciesUseCases.prepopulatedDebit;
  CurrencyDto getInitialCredit() => _currenciesUseCases.prepopulatedCredit;

  /// Метод загрузки данных для экрана
  Future<List<CurrencyDto>> loadData() async {
    try {
      final debitToCreditCurrencies = await _currenciesUseCases
          .getDebitToCreditCurrencies(_currentDebitCurrency.code);
      _currencies = debitToCreditCurrencies.allCurrencies;
      
      _currentDebitCurrency = debitToCreditCurrencies.debitCurrency;
      _currentCreditCurrency = debitToCreditCurrencies.creditCurrencies
          .getByCode(_currentCreditCurrency.code);
      return _currencies;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Метод, меняющий текущую валюту зачисления на валюту, имеющую код [currencyCode]
  CurrencyDto switchCreditTo(String currencyCode) {
    try {
      return _currentCreditCurrency = _currencies.getByCode(currencyCode);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Метод, меняющий текущую валюту списания на валюту, имеющую код [currencyCode]
  Future<CurrencyDto> switchDebitTo(String currencyCode) async {
    try {
      _currentDebitCurrency = _currencies.getByCode(currencyCode);
      await loadData();
      return _currentDebitCurrency;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
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
