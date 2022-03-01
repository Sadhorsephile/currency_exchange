import 'package:currency_exchange/core/presentation/screens/main/data.dart';
import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
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
        appBarTitle: 'Currency exchange',
        debitHint: 'Списание',
        creditHint: 'Зачисление',
        horizontalPadding: 20.0,
        verticalPadding: 10.0,
        spacing: 10.0,
        backgroundColor: Colors.grey[100]!,
        errorTextColor: Colors.red,
        refreshIconColor: Colors.blue,
        shimmerBaseColor: Colors.grey[100]!,
        shimmerHighlightColor: Colors.grey[300]!,
        textFieldDecoration: const InputDecoration(
          fillColor: Colors.white,
          filled: true,
        ),
      );

  /// Флаг, символизирующий, заблокированы ли для обработчиков-слушателей контроллеры
  bool _isControllersLocked = false;

  MainScreenWidgetModel(
    MainScreenModel model,
    this._debitController,
    this._creditController,
  ) : super(model) {
    _subscribeControllerListeners();
    _init();
  }

  @override
  void onRetryPressed() {
    _init();
  }

  /// Метод подписки слушателей на контроллер
  void _subscribeControllerListeners() {
    _creditController.addListener(_onCreditChange);
    _debitController.addListener(_onDebitChange);
  }

  /// Метод инциализации данных, необходимых для функционирования экрана
  void _init() {
    _creditStateNotifier.loading();
    _debitStateNotifier.loading();

    model.loadData().then((_) {
      _creditStateNotifier
          .content(CurrencyTextFieldDto(_creditController, r'$'));
      _debitStateNotifier.content(CurrencyTextFieldDto(_debitController, '₽'));
    });
  }

  /// Метод, обновляющий содержимое поля зачисления в ответ на изменение содержимого поля списания
  void _onDebitChange() {
    if (_isControllersLocked) return;

    _debitController.validateDecimalNumber();
    final debit = _debitController.text.toDoubleOrNull;
    if (debit == null) return;
    _modifyWithoutListenerTriggers(
      () => _creditController.setDoubleValue(model.fromDebitToCredit(debit)),
    );
  }

  /// Метод, обновляющий содержимое поля зачисления в ответ на изменение содержимого поля списания
  void _onCreditChange() {
    if (_isControllersLocked) return;

    _creditController.validateDecimalNumber();
    final credit = _creditController.text.toDoubleOrNull;
    if (credit == null) return;
    _modifyWithoutListenerTriggers(
      () => _debitController.setDoubleValue(model.fromCreditToDebit(credit)),
    );
  }

  /// Метод, позволяющий выполнять модификацию значений контроллера, не вызывая
  /// реакции слушателей модифицируемого контроллера путем установки соответствующего флага
  void _modifyWithoutListenerTriggers(VoidCallback modify) {
    _isControllersLocked = true;
    modify();
    _isControllersLocked = false;
  }
}

/// Интерфейс виджет-модели
abstract class IMainScreenWidgetModel
    extends WidgetModel<MainScreen, MainScreenModel> {
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

  IMainScreenWidgetModel(MainScreenModel model) : super(model);

  /// Метод, инициирующий перезагрузку данных на странице
  void onRetryPressed();
}
