import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/resources/colors.dart';
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Фабрика виджет-модели главного экрана
IMainScreenWidgetModel mainScreenWidgetModelFactory(BuildContext _) =>
    MainScreenWidgetModel(
      MainScreenModel(),
      TextEditingController(),
      TextEditingController(),
    );

/// Виджет-модель главного экрана
class MainScreenWidgetModel extends IMainScreenWidgetModel {
  /// Контроллер текстового поля списания
  final TextEditingController _debitController;

  /// Контроллер текстового поля зачисления
  final TextEditingController _creditController;

  final _debitStateNotifier = EntityStateNotifier<CurrencyTextFieldDto>();
  final _creditStateNotifier = EntityStateNotifier<CurrencyTextFieldDto>();

  @override
  ListenableState<EntityState<CurrencyTextFieldDto>> get debitTextFieldState =>
      _debitStateNotifier;
  @override
  ListenableState<EntityState<CurrencyTextFieldDto>> get creditTextFieldState =>
      _creditStateNotifier;
  @override
  Orientation get orientation => MediaQuery.of(context).orientation;

  @override
  UiElementsProperties get uiElementsProperties => UiElementsProperties(
        appBarTitle: AppDictionary.mainScreenAppBarTitle,
        debitHint: AppDictionary.mainScreenDebitHint,
        creditHint: AppDictionary.mainScreenCreditHint,
        horizontalPadding: 20.0,
        verticalPadding: 10.0,
        spacing: 10.0,
        backgroundColor: AppColors.mainScreenBackgroundColor,
        errorTextColor: AppColors.mainScreenErrorTextColor,
        refreshIconColor: AppColors.refreshIconColor,
        shimmerBaseColor: AppColors.shimmerBaseColor,
        shimmerHighlightColor: AppColors.shimmerHighlightColor,
        textFieldDecoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
        ),
      );

  MainScreenWidgetModel(
    MainScreenModel model,
    this._debitController,
    this._creditController,
  ) : super(model) {
    _debitStateNotifier.content(CurrencyTextFieldDto(_debitController, '₽'));
    _creditStateNotifier.content(CurrencyTextFieldDto(_creditController, r'$'));
  }
}

/// Интерфейс виджет-модели
abstract class IMainScreenWidgetModel extends WidgetModel {
  /// Источник состояния текстового поля списания
  ListenableState<EntityState<CurrencyTextFieldDto>> get debitTextFieldState;

  /// Источник состояния текстового поля зачисления
  ListenableState<EntityState<CurrencyTextFieldDto>> get creditTextFieldState;

  /// Текущее состояние ориентации устройства
  Orientation get orientation;
  UiElementsProperties get uiElementsProperties;

  /// Форматтер для поля ввода количества валюты (позволяет вводить только числа и знак разделения '.')
  TextInputFormatter get inputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[\d\.]'));

  IMainScreenWidgetModel(ElementaryModel model) : super(model);
}

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
