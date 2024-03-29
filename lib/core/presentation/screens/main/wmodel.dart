import 'package:currency_exchange/common/utils/snackbar_messenger.dart';
import 'package:currency_exchange/core/data/network/client.dart';
import 'package:currency_exchange/core/data/network/service/get_exchange_rates.dart';
import 'package:currency_exchange/core/data/repository/currency.dart';
import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/interactor/get_exchange_rates.dart';
import 'package:currency_exchange/core/presentation/screens/main/error_handler.dart';
import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
import 'package:currency_exchange/core/presentation/screens/main/modal.dart';
import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:currency_exchange/core/presentation/screens/main/utils.dart';
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Фабрика виджет-модели главного экрана
IMainScreenWidgetModel mainScreenWidgetModelFactory(BuildContext _) =>
    MainScreenWidgetModel(
      MainScreenModel(
        CurrenciesUseCasesImpl(
          CurrencyRepositoryImpl(
            GetExchangeRatesApiImpl(
              Provider.of<NetworkClient>(_, listen: false),
            ),
          ),
        ),
        MainScreenErrorHandler(),
      ),
      TextEditingController(),
      TextEditingController(),
      SnackBarMessengerImpl(_),
    );

/// Виджет-модель главного экрана
class MainScreenWidgetModel extends IMainScreenWidgetModel {
  /// Контроллер текстового поля списания
  final TextEditingController _debitController;

  final SnackBarMessenger _snackBarMessenger;

  /// Контроллер текстового поля зачисления
  final TextEditingController _creditController;

  final _debitStateNotifier = EntityStateNotifier<CurrencyTextFieldDto>();
  final _creditStateNotifier = EntityStateNotifier<CurrencyTextFieldDto>();

  final _currencies = ValueNotifier<List<CurrencyDto>>([]);

  @override
  ListenableState<EntityState<CurrencyTextFieldDto>> get debitTextFieldState =>
      _debitStateNotifier;
  @override
  ListenableState<EntityState<CurrencyTextFieldDto>> get creditTextFieldState =>
      _creditStateNotifier;

  @override
  ValueListenable<List<CurrencyDto>> get currencies => _currencies;

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
    this._snackBarMessenger,
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
    _snackBarMessenger.showSnackBar(
      error is Exception
          ? error.asUserError
          : AppDictionary.mainScreenUnexpectedError,
    );
  }

  @override
  void onRetryPressed() {
    _init();
  }

  @override
  void openSelectCreditModalSheet() {
    SelectCurrencyModalBottomSheet.show(
      context,
      currencies,
      onSelectCredit,
    );
  }

  @override
  void openSelectDebitModalSheet() {
    SelectCurrencyModalBottomSheet.show(
      context,
      currencies,
      onSelectDebit,
    );
  }

  @override
  void onSelectDebit(CurrencyDto currency) {
    if (currency.code == model.credit.code) {
      _onSameCurrenciesSelect();
      return;
    }

    _creditStateNotifier.loading();
    _debitStateNotifier.content(CurrencyTextFieldDto(
      _debitController,
      currency.symbol,
    ));

    model.switchDebitTo(currency).then((_) {
      _creditStateNotifier.content(
        CurrencyTextFieldDto(
          _creditController,
          model.credit.symbol,
        ),
      );
      _onDebitChange();
    });
  }

  @override
  void onSelectCredit(CurrencyDto currency) {
    if (currency.code == model.debit.code) {
      _onSameCurrenciesSelect();
      return;
    }

    model.switchCreditTo(currency);
    _creditStateNotifier.content(CurrencyTextFieldDto(
      _creditController,
      currency.symbol,
    ));
    _onCreditChange();
  }

  /// Метод подписки слушателей на контроллер
  void _subscribeControllerListeners() {
    _creditController.addListener(_onCreditChange);
    _debitController.addListener(_onDebitChange);
  }

  /// Метод инциализации данных, необходимых для функционирования экрана
  Future<void> _init() async {
    _creditStateNotifier.loading();
    _debitStateNotifier.loading();

    try {
      await model.loadData();
      _currencies.value = model.currencies;

      _creditStateNotifier.content(CurrencyTextFieldDto(
        _creditController,
        model.credit.symbol,
      ));
      _debitStateNotifier.content(CurrencyTextFieldDto(
        _debitController,
        model.debit.symbol,
      ));
    } on Exception catch (e) {
      _debitStateNotifier.error(
        e,
        CurrencyTextFieldDto(
          _debitController,
          model.debit.symbol,
        ),
      );
    }
  }

  /// Метод, обновляющий содержимое поля зачисления в ответ на изменение содержимого поля списания
  void _onDebitChange() => _onTextChange(
        _debitController,
        _creditController,
        model.fromDebitToCredit,
      );

  /// Метод, обновляющий содержимое поля зачисления в ответ на изменение содержимого поля списания
  void _onCreditChange() => _onTextChange(
        _creditController,
        _debitController,
        model.fromCreditToDebit,
      );

  /// Метод, выполняющий преобразование значения [passiveController] в зависимости от значения [activeController].
  /// Преобразование определяется функцией [transformer]
  void _onTextChange(
    TextEditingController activeController,
    TextEditingController passiveController,
    double Function(double) transformer,
  ) {
    if (_isControllersLocked) return;
    activeController.validateDecimalNumber();
    final value = activeController.text.toDoubleOrNull;
    if (value == null) return;
    _modifyWithoutListenersTrigger(() {
      passiveController.setDoubleValue(transformer(value));
    });
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
  Future<void> _showSnackBarMessage(String message) async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
    );
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
  ValueListenable<List<CurrencyDto>> get currencies;

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

  void openSelectDebitModalSheet();

  void openSelectCreditModalSheet();

  /// Метод, вызываемый в момент выбора валюты списания для конвертации
  void onSelectDebit(CurrencyDto currency);

  /// Метод, вызываемый в момент выбора валюты зачисления для конвертации
  void onSelectCredit(CurrencyDto currency);
}
