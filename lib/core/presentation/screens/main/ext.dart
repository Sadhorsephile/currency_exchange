import 'package:currency_exchange/common/utils/exceptions.dart';
import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:flutter/material.dart';

/// Адаптер из [double] в [String]
extension DoubleToStringAdapter on String {
  double? get toDoubleOrNull {
    if (isEmpty) return 0;
    return double.tryParse(this);
  }
}

/// Расширение, позволяющее получить валюту по ее коду
extension GetByCodeCurrencyRetriever on List<CurrencyDto> {
  CurrencyDto getByCode(String currencyCode) => firstWhere(
        (e) => e.code == currencyCode,
        orElse: throw Exception('No currency found with code = $currencyCode'),
      );
}

/// Валидатор вещественного числа
extension DoubleValidator on TextEditingController {
  /// Устанавливает в поле текста вещественное число или ничего, если указан 0
  void setDoubleValue(double value) {
    text = value == 0 ? '' : value.toStringAsFixed(2);
  }

  /// Валидирует введенное число таким образом, чтобы оно соответствовало формату ###.##
  void validateDecimalNumber() {
    if (text.isEmpty) return;

    // проверка, является ли введенный текст валидным числом
    final isValid = double.tryParse(text) != null;

    // если нет, требуется удаление последнего введенного символа (чтобы содержимое контроллера оставалось валидным числом или пустым)
    if (!isValid) {
      final position = selection.baseOffset;
      final textWithoutLastEnteredSymbol =
          text.substring(0, position - 1) + text.substring(position);

      value = TextEditingValue(
        text: textWithoutLastEnteredSymbol,
        selection: TextSelection.collapsed(offset: position - 1),
      );
    }

    if (!text.contains('.')) return;

    final parts = text.split('.');

    // Проверка на наличие дробной части
    if (parts.length < 2) return;
    // Проверка на наличие сотой доли в дробной части
    if (parts.last.length < 2) return;

    final position = value.selection.baseOffset;

    final resultText = '${parts.first}.${parts.last.substring(0, 2)}';

    final resultPosition = position > text.length ? text.length : position;

    value = TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(offset: resultPosition),
    );
  }
}

/// Расширение-адаптер, преобразующее исключение в текстовую форму,
/// приемлимую для пользователя
extension ExceptionTextRetriever on Exception? {
  String get asUserError {
    if (this is NoCurrencyCacheFoundException) {
      return AppDictionary.mainScreenNoCacheError;
    } else if (this is OnlyCacheAvailableException) {
      return AppDictionary.mainScreenOnlyCacheAvailableError;
    }
    return AppDictionary.mainScreenUnexpectedError;
  }
}
