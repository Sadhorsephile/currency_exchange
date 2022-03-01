import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
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
  @override
  TextInputFormatter get inputFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[\d\.]'));

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
  TextInputFormatter get inputFormatter;

  IMainScreenWidgetModel(MainScreenModel model) : super(model);

  /// Метод, инициирующий перезагрузку данных на странице
  void onRetryPressed();
}
