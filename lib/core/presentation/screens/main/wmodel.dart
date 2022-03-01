import 'package:currency_exchange/core/presentation/screens/main/error_handler.dart';
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
      MainScreenModel(MainScreenErrorHandler()),
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
  List<CurrencyInfoDto> get currencies =>
      model.currencies.value.map((e) => e.toCurrencyInfoDto).toList();

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
  ) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _subscribeControllerListeners();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _debitController
      ..removeListener(_onDebitChange)
      ..dispose();
    _creditController
      ..removeListener(_onCreditChange)
      ..dispose();
  }

  @override
  void onErrorHandle(Object error) {
    _showSnackBarMessage(AppDictionary.mainScreenUnexpectedError);
  }

  @override
  void onRetryPressed() {
    _init();
  }

  @override
  void onSelectDebit(CurrencyInfoDto currency) {
    if (currency.code == model.currentCreditCurrency.code) {
      _onSameCurrenciesSelect();
      return;
    }

    _creditStateNotifier.loading();
    _debitStateNotifier.content(CurrencyTextFieldDto(
      _debitController,
      currency.currencySymbol,
    ));

    model.switchDebitTo(currency.code).then((_) {
      _creditStateNotifier.content(
        CurrencyTextFieldDto(
          _creditController,
          model.currentCreditCurrency.symbol,
        ),
      );
      _onDebitChange();
    });
  }

  @override
  void onSelectCredit(CurrencyInfoDto currency) {
    if (currency.code == model.currentDebitCurrency.code) {
      _onSameCurrenciesSelect();
      return;
    }

    model.switchCreditTo(currency.code);
    _creditStateNotifier.content(CurrencyTextFieldDto(
      _creditController,
      currency.currencySymbol,
    ));
    _onCreditChange();
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
      _creditStateNotifier.content(CurrencyTextFieldDto(
        _creditController,
        model.currentCreditCurrency.symbol,
      ));
      _debitStateNotifier.content(CurrencyTextFieldDto(
        _debitController,
        model.currentDebitCurrency.symbol,
      ));
    });
  }

  /// Метод, обновляющий содержимое поля зачисления в ответ на изменение содержимого поля списания
  void _onDebitChange() {
    if (_isControllersLocked) return;

    _debitController.validateDecimalNumber();
    final debit = _debitController.text.toDoubleOrNull;
    if (debit == null) return;
    _modifyWithoutListenersTrigger(
      () => _creditController.setDoubleValue(model.fromDebitToCredit(debit)),
    );
  }

  /// Метод, обновляющий содержимое поля зачисления в ответ на изменение содержимого поля списания
  void _onCreditChange() {
    if (_isControllersLocked) return;

    _creditController.validateDecimalNumber();
    final credit = _creditController.text.toDoubleOrNull;
    if (credit == null) return;
    _modifyWithoutListenersTrigger(
      () => _debitController.setDoubleValue(model.fromCreditToDebit(credit)),
    );
  }

  /// Метод, позволяющий выполнять модификацию значений контроллера, не вызывая
  /// реакции слушателей модифицируемого контроллера путем установки соответствующего флага
  void _modifyWithoutListenersTrigger(VoidCallback modify) {
    _isControllersLocked = true;
    modify();
    _isControllersLocked = false;
  }

  /// Метод, отображающий снек-бар с предупреждением
  void _onSameCurrenciesSelect() {
    _showSnackBarMessage(AppDictionary.mainScreenSameCurrenciesSelectedWarning);
  }

  /// Метод, отображающий снек-бар с сообщением [message]
  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Интерфейс виджет-модели
abstract class IMainScreenWidgetModel
    extends WidgetModel<MainScreen, MainScreenModel> {
  /// Источник состояния текстового поля списания
  ListenableState<EntityState<CurrencyTextFieldDto>> get debitTextFieldState;

  /// Источник состояния текстового поля зачисления
  ListenableState<EntityState<CurrencyTextFieldDto>> get creditTextFieldState;

  /// Источник данных о списках доступных для конвертации валют
  List<CurrencyInfoDto> get currencies;

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

  /// Метод, вызываемый в момент выбора валюты списания для конвертации
  void onSelectDebit(CurrencyInfoDto currency);

  /// Метод, вызываемый в момент выбора валюты зачисления для конвертации
  void onSelectCredit(CurrencyInfoDto currency);
}
