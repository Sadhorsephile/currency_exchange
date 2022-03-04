import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/domain/usecases/get_exchange_rates.dart';
import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:elementary/elementary.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  final CurrenciesUseCases _currenciesUseCases;

  CurrencyDto get debit => _currentDebitCurrency;
  CurrencyDto get credit => _currentCreditCurrency;
  List<CurrencyDto> get currencies => _currencies;

  late CurrencyDto _currentDebitCurrency;
  late CurrencyDto _currentCreditCurrency;

  var _currencies = <CurrencyDto>[];

  MainScreenModel(
    this._currenciesUseCases,
    ErrorHandler errorHandler,
  ) : super(errorHandler: errorHandler);

  @override
  void init() {
    _currentDebitCurrency = _currenciesUseCases.prepopulatedDebit;
    _currentCreditCurrency = _currenciesUseCases.prepopulatedCredit;
  }

  /// Метод загрузки данных для wm.
  /// Осуществляет загрузку данных (курс валюты списания к остальным валютам)
  /// на основе текущей валюты списания [debit].
  ///
  /// Обновляет содержимое полей [debit], [credit] и [currencies].
  Future<void> loadData() async {
    try {
      final data = await _currenciesUseCases
          .getDebitToCreditCurrencies(_currentDebitCurrency.code);
      _currencies = data.allCurrencies;
      _currentDebitCurrency = data.debitCurrency;
      _currentCreditCurrency =
          data.allCurrencies.getByCode(_currentCreditCurrency.code);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Метод, меняющий текущую валюту зачисления [credit] на [currency]
  // ignore: use_setters_to_change_properties
  void switchCreditTo(CurrencyDto currency) {
    _currentCreditCurrency = currency;
  }

  /// Метод, меняющий текущую валюту списания [debit] на [currency].
  /// После замены валюты списания осуществляет обновление данных (курс валюты списания к остальным валютам)
  Future<void> switchDebitTo(CurrencyDto currency) async {
    _currentDebitCurrency = currency;
    await loadData();
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
