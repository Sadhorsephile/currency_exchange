
import 'package:flutter/material.dart';

/// Дата-класс, держащий в себе данные о валюте и ее введенном количестве
class CurrencyTextFieldDto {
  final TextEditingController controller;
  final String currencySymbol;

  CurrencyTextFieldDto(this.controller, this.currencySymbol);
}

/// Набор значений, задающих свойство ui-элементов
class UiElementsProperties {
  /// Текст шапки страницы
  final String appBarTitle;

  /// Хинт текстового поля списания
  final String debitHint;

  /// Хинт текстового поля зачисления
  final String creditHint;

  /// Значение горизонтального отступа
  final double horizontalPadding;

  /// Значение вертикального отступа
  final double verticalPadding;

  /// Значение отступа между элементами
  final double spacing;

  /// Цвет заднего фона экрана
  final Color backgroundColor;

  /// Конфигурация внешнего вида текстового поля
  final InputDecoration textFieldDecoration;

  /// Цвет текста ошибки
  final Color errorTextColor;

  /// Цвет иконки повтора запроса
  final Color refreshIconColor;

  /// Базовый цвет шиммера
  final Color shimmerBaseColor;

  /// Цвет подсветки шиммера
  final Color shimmerHighlightColor;

  UiElementsProperties({
    required this.appBarTitle,
    required this.debitHint,
    required this.creditHint,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.spacing,
    required this.backgroundColor,
    required this.textFieldDecoration,
    required this.errorTextColor,
    required this.refreshIconColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
  });
}

