import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:elementary/elementary.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  late CurrencyDto _currentDebitCurrency;
  late CurrencyDto _currentCreditCurrency;

  var _currencies = <CurrencyDto>[];

  MainScreenModel(ErrorHandler errorHandler)
      : super(errorHandler: errorHandler);

  @override
  void init() {
    _currentDebitCurrency = getInitialDebit();
    _currentCreditCurrency = getInitialCredit();
  }

  CurrencyDto getInitialDebit() => _rub;
  CurrencyDto getInitialCredit() => _usd;

  /// Метод загрузки данных для экрана
  Future<List<CurrencyDto>> loadData() async {
    try {
      _currencies = _mockCurrencies;

      _currentDebitCurrency = _rub;
      _currentCreditCurrency = _usd;
      return _currencies;
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Метод, меняющий текущую валюту зачисления на валюту, имеющую код [currencyCode]
  CurrencyDto switchCreditTo(String currencyCode) {
    try {
      return _currentCreditCurrency = _mockCurrencies.getByCode(currencyCode);
    } on Exception catch (e) {
      handleError(e);
      rethrow;
    }
  }

  /// Метод, меняющий текущую валюту списания на валюту, имеющую код [currencyCode]
  Future<CurrencyDto> switchDebitTo(String currencyCode) async {
    try {
      _currentDebitCurrency = _mockCurrencies.getByCode(currencyCode);
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
