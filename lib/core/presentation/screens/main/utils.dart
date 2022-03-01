import 'package:currency_exchange/common/utils/exceptions.dart';
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:flutter/material.dart';

/// Дата-класс, держащий в себе данные о валюте и ее введенном количестве
class CurrencyTextFieldDto {
  final TextEditingController controller;
  final String currencySymbol;

  CurrencyTextFieldDto(this.controller, this.currencySymbol);
}


class CurrencyInfoDto {
  final String title;
  final String code;
  final String currencySymbol;

  CurrencyInfoDto(this.title, this.currencySymbol, this.code);
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
