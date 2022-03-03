import 'package:currency_exchange/common/utils/exceptions.dart';
import 'package:currency_exchange/common/utils/snackbar_messenger.dart';
import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:currency_exchange/core/presentation/screens/main/wmodel.dart';
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:elementary_test/elementary_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

part 'wmodel_test.mock.dart';

class MainScreenModelMock extends Mock implements MainScreenModel {}

class SnackBarMessengerMock extends Mock implements SnackBarMessenger {}

class NoCurrencyCacheFoundExceptionMock extends Mock
    implements NoCurrencyCacheFoundException {}

void main() {
  group(
    'Main screen wm testing:',
    () {
      late MainScreenModelMock modelData;
      late TextEditingController debitController;
      late TextEditingController creditController;
      late SnackBarMessengerMock _snackBarMessengerMock;

      MainScreenWidgetModel setupWm() {
        modelData = MainScreenModelMock();
        debitController = TextEditingController();
        creditController = TextEditingController();
        _snackBarMessengerMock = SnackBarMessengerMock();

        when(() => modelData.loadData())
            .thenAnswer((_) => Future.value(_mockCurrencies));
        when(() => modelData.getInitialCredit()).thenReturn(_usd);
        when(() => modelData.getInitialDebit()).thenReturn(_rub);
        when(() => modelData.switchDebitTo(_rubCode))
            .thenAnswer((_) => Future.value(_rub));

        return MainScreenWidgetModel(
          modelData,
          debitController,
          creditController,
          _snackBarMessengerMock,
        );
      }

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Supplied to screen data is correct',
        setupWm,
        (wm, tester, context) {
          tester.init();

          expect(wm.appBarTitle, AppDictionary.mainScreenAppBarTitle);
          expect(wm.creditHint, AppDictionary.mainScreenCreditHint);
          expect(wm.debitHint, AppDictionary.mainScreenDebitHint);
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Verify wm init data loading',
        setupWm,
        (wm, tester, context) async {
          tester.init();
          verify<void>(modelData.loadData);
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Initial currencies are correct',
        setupWm,
        (wm, tester, context) async {
          tester.init();

          await modelData.loadData();

          expect(
            wm.creditTextFieldState.value?.data?.currencySymbol,
            _initialCreditCurrency.symbol,
          );
          expect(
            wm.debitTextFieldState.value?.data?.currencySymbol,
            _initialDebitCurrency.symbol,
          );
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Convertation from debit to credit is correct',
        setupWm,
        (wm, tester, context) async {
          when(() => modelData.fromDebitToCredit(1)).thenReturn(120);

          tester.init();

          debitController.text = '1';
          expect(creditController.text, '120.00');
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Convertation from credit to debit is correct',
        setupWm,
        (wm, tester, context) async {
          when(() => modelData.fromCreditToDebit(120)).thenReturn(1);

          tester.init();

          creditController.text = '120';
          expect(debitController.text, '1.00');
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Switch to another credit currency is correct',
        setupWm,
        (wm, tester, context) async {
          tester.init();

          when(() => modelData.switchCreditTo(_eurCode)).thenReturn(_usd);
          when(() => modelData.fromCreditToDebit(0)).thenReturn(0);

          wm.onSelectCredit(_eur);

          verify<void>(() => modelData.switchCreditTo(_eurCode));

          expect(
            wm.creditTextFieldState.value?.data?.currencySymbol,
            _eur.symbol,
          );
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Switch to another debit currency is correct',
        setupWm,
        (wm, tester, context) async {
          tester.init();

          when(() => modelData.switchDebitTo(_eurCode))
              .thenAnswer((_) => Future.value(_eur));
          when(() => modelData.fromDebitToCredit(0)).thenReturn(0);

          wm.onSelectDebit(_eur);

          verify<void>(() => modelData.switchDebitTo(_eurCode));

          expect(
            wm.debitTextFieldState.value?.data?.currencySymbol,
            _eur.symbol,
          );
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Switching debit to same currency as credit throws error',
        setupWm,
        (wm, tester, context) async {
          tester.init();

          when(() => modelData.fromDebitToCredit(0)).thenReturn(0);

          await modelData.loadData();

          expect(
            wm.creditTextFieldState.value?.data?.currencySymbol,
            _initialCreditCurrency.symbol,
          );

          wm.onSelectDebit(_initialCreditCurrency);

          verify<void>(
            () => _snackBarMessengerMock.showSnackBar(
              AppDictionary.mainScreenSameCurrenciesSelectedWarning,
            ),
          );
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Switching credit to same currency as debit throws error',
        setupWm,
        (wm, tester, context) async {
          tester.init();

          when(() => modelData.fromCreditToDebit(0)).thenReturn(0);

          await modelData.loadData();

          expect(
            wm.debitTextFieldState.value?.data?.currencySymbol,
            _initialDebitCurrency.symbol,
          );

          wm.onSelectCredit(_initialDebitCurrency);

          verify<void>(
            () => _snackBarMessengerMock.showSnackBar(
              AppDictionary.mainScreenSameCurrenciesSelectedWarning,
            ),
          );
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Must show snackbar if cannot load cache',
        setupWm,
        (wm, tester, context) async {
          final exception = NoCurrencyCacheFoundExceptionMock();

          when(modelData.loadData).thenThrow(exception);

          tester.init();
          await Future<void>.delayed(const Duration(seconds: 1));
          wm.onErrorHandle(exception);

          expect(wm.debitTextFieldState.value?.error, exception);
          verify<void>(modelData.loadData);
          verify<void>(
            () => _snackBarMessengerMock.showSnackBar(
              AppDictionary.mainScreenNoCacheError,
            ),
          );
        },
      );

      testWidgetModel<MainScreenWidgetModel, MainScreen>(
        'Must show snackbar if unexpected error occurs',
        setupWm,
        (wm, tester, context) async {
          final exception = Exception();

          when(modelData.loadData).thenThrow(exception);

          tester.init();
          await Future<void>.delayed(const Duration(seconds: 1));
          wm.onErrorHandle(exception);

          expect(wm.debitTextFieldState.value?.error, exception);
          verify<void>(modelData.loadData);
          verify<void>(
            () => _snackBarMessengerMock.showSnackBar(
              AppDictionary.mainScreenUnexpectedError,
            ),
          );
        },
      );
    },
  );
}
