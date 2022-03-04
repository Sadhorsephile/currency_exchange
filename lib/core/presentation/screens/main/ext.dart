import 'package:currency_exchange/common/utils/exceptions.dart';
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:flutter/material.dart';

/// Адаптер из [double] в [String]
extension DoubleToStringAdapter on String {
  double? get toDoubleOrNull {
    if (isEmpty) return 0;
    return double.tryParse(this);
  }
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

    final validator = RegExp(r'^[0-9]+\.?[0-9]{0,2}$');

    if (validator.hasMatch(text)) return;
    
    _removeLastEnteredCharacter();
  }

  void _removeLastEnteredCharacter() {
    final position = selection.baseOffset;
    final textWithoutLastEnteredSymbol =
        text.substring(0, position - 1) + text.substring(position);

    value = TextEditingValue(
      text: textWithoutLastEnteredSymbol,
      selection: TextSelection.collapsed(offset: position - 1),
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
