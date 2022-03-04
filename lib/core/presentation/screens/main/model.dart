import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:elementary/elementary.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  CurrencyDto get debit => _currentDebitCurrency;
  CurrencyDto get credit => _currentCreditCurrency;
  List<CurrencyDto> get currencies => _currencies;

  late CurrencyDto _currentDebitCurrency;
  late CurrencyDto _currentCreditCurrency;

  var _currencies = <CurrencyDto>[];

  MainScreenModel(ErrorHandler errorHandler)
      : super(errorHandler: errorHandler);

  @override
  void init() {
    // TODO: брать из интерактора
    _currentDebitCurrency = _getInitialDebit();
    _currentCreditCurrency = _getInitialCredit();
  }

  /// Метод загрузки данных для wm.
  /// Осуществляет загрузку данных (курс валюты списания к остальным валютам)
  /// на основе текущей валюты списания [debit].
  ///
  /// Обновляет содержимое полей [debit], [credit] и [currencies].
  Future<void> loadData() async {
    try {
      // TODO: грузить данные из интерактора
      _currencies = _mockCurrencies;
      _currentDebitCurrency = _rub;
      _currentCreditCurrency = _usd;
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

  // TODO: вынести в интерактор
  CurrencyDto _getInitialDebit() => _rub;
  CurrencyDto _getInitialCredit() => _usd;
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
