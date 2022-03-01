import 'package:elementary/elementary.dart';

/// Модель главного экрана
class MainScreenModel extends ElementaryModel {
  final _mockCurrency = 120;

  /// Метод загрузки данных для экрана
  Future<void> loadData() {
    return Future<void>.delayed(const Duration(seconds: 2));
  }

  /// Метод преобразования из валюты списания в валюту зачисления
  double fromDebitToCredit(double debit) {
    return debit * _mockCurrency;
  }

  /// Метод преобразования из валюты зачисления в валюту списания
  double fromCreditToDebit(double credit) {
    return credit / _mockCurrency;
  }
}
