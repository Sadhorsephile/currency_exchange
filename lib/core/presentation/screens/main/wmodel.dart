import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/core/presentation/screens/main/utils.dart';
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
  String get appBarTitle => AppDictionary.mainScreenAppBarTitle;
  @override
  String get debitHint => AppDictionary.mainScreenDebitHint;
  @override
  String get creditHint => AppDictionary.mainScreenCreditHint;
  @override
  double get horizontalPadding => 20.0;
  @override
  double get verticalPadding => 10.0;
  @override
  double get spacing => 10.0;

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

  /// Текст шапки страницы
  String get appBarTitle;

  /// Хинт текстового поля списания
  String get debitHint;

  /// Хинт текстового поля зачисления
  String get creditHint;

  /// Значение горизонтального отступа
  double get horizontalPadding;

  /// Значение вертикального отступа
  double get verticalPadding;

  /// Значение отступа между элементами
  double get spacing;

  /// Форматтер для поля ввода количества валюты (позволяет вводить только числа и знак разделения '.')
  TextInputFormatter get inputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[\d\.]'));

  IMainScreenWidgetModel(ElementaryModel model) : super(model);
}


