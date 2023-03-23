import 'package:currency_exchange/core/data/network/models/currency.dart';
import 'package:currency_exchange/core/data/network/service/get_exchange_rates.dart';
import 'package:currency_exchange/main.dart' as app;
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock.dart';

class GetExchangeRatesApiMock extends Mock implements GetExchangeRatesApi {}

// 12 eur - 13.03 usd
// 12 usd - 11.06 eur
// 12 rub - 0.16 usd

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final api = GetExchangeRatesApiMock();

  setUp(() {
    when(() => api('EUR')).thenAnswer(
      (_) => Future.value(
        CurrencyNetworkDto(
          'EUR',
          euroMock,
        ),
      ),
    );
    when(() => api('RUB')).thenAnswer(
      (_) => Future.value(
        CurrencyNetworkDto(
          'RUB',
          rubMock,
        ),
      ),
    );
  });

  testWidgets(
    'Ввод значения в первое поле - изменение во втором',
    (tester) async {
      await app.main([], api);
      await tester.pumpAndSettle();

      /// Ищем текстовые поля
      final debitTF = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.decoration?.hintText == AppDictionary.mainScreenDebitHint);
      final creditTF = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.decoration?.hintText == AppDictionary.mainScreenCreditHint);

      /// И кнопки
      final debitBtn = find.widgetWithText(ClipOval, '€');
      final creditBtn = find.widgetWithText(ClipOval, r'$');

      /// Убеждаемся, что они есть на экране
      expect(debitTF, findsOneWidget);
      expect(creditTF, findsOneWidget);
      expect(debitBtn, findsOneWidget);
      expect(creditBtn, findsOneWidget);

      /// Вводим цифру в первое поле
      await tester.enterText(debitTF, '12');

      await tester.pumpAndSettle();

      /// И ожидаем правильный результат во втором поле
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == AppDictionary.mainScreenCreditHint &&
              w.controller?.text == '13.03',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Ввод значения во второе поле - изменение в первом',
    (tester) async {
      await app.main([], api);
      await tester.pumpAndSettle();

      /// Ищем текстовые поля
      final debitTF = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.decoration?.hintText == AppDictionary.mainScreenDebitHint);
      final creditTF = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.decoration?.hintText == AppDictionary.mainScreenCreditHint);

      /// И кнопки
      final debitBtn = find.widgetWithText(ClipOval, '€');
      final creditBtn = find.widgetWithText(ClipOval, r'$');

      /// Убеждаемся, что они есть на экране
      expect(debitTF, findsOneWidget);
      expect(creditTF, findsOneWidget);
      expect(debitBtn, findsOneWidget);
      expect(creditBtn, findsOneWidget);

      /// Вводим цифру во второе поле
      await tester.enterText(creditTF, '12');

      await tester.pumpAndSettle();

      /// И ожидаем правильный результат в первом поле
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == AppDictionary.mainScreenDebitHint &&
              w.controller?.text == '11.06',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Переключение валюты в первом поле - изменение во втором',
    (tester) async {
      await app.main([], api);
      await tester.pumpAndSettle();

      /// Ищем текстовые поля
      final debitTF = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.decoration?.hintText == AppDictionary.mainScreenDebitHint);
      final creditTF = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.decoration?.hintText == AppDictionary.mainScreenCreditHint);

      /// Находим кнопки
      final debitBtn = find.widgetWithText(ClipOval, '€');
      final creditBtn = find.widgetWithText(ClipOval, r'$');

      /// Убеждаемся, что они есть на экране
      expect(debitTF, findsOneWidget);
      expect(creditTF, findsOneWidget);
      expect(debitBtn, findsOneWidget);
      expect(creditBtn, findsOneWidget);

      await tester.enterText(debitTF, '12');

      /// Нажимаем на кнопку переключения валюты первого поля
      await tester.tap(debitBtn);
      await tester.pumpAndSettle();
      final debitlist = find.byType(ListView);

      /// Будем переключаться на рубль
      final debitItem = find.widgetWithText(InkWell, 'Russia Ruble');

      expect(debitlist, findsOneWidget);

      /// Драгаем, пока не найдём искомый элемент
      await tester.dragUntilVisible(
        debitItem,
        debitlist,
        const Offset(0, -200),
      );

      await tester.tap(debitItem);

      /// Ждём, пока все устаканится + пройдёт запрос
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      /// И ожидаем правильный результат во втором поле
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == AppDictionary.mainScreenCreditHint &&
              w.controller?.text == '0.16',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Установка одинаковой валюты в первом и втором поле',
    (tester) async {
      await app.main([], api);
      await tester.pumpAndSettle();

      /// Находим кнопки
      final debitBtn = find.widgetWithText(ClipOval, '€');
      final creditBtn = find.widgetWithText(ClipOval, r'$');

      /// Убеждаемся, что они есть на экране
      expect(debitBtn, findsOneWidget);
      expect(creditBtn, findsOneWidget);

      /// Нажимаем на кнопку переключения валюты второго поля
      await tester.tap(creditBtn);
      await tester.pumpAndSettle();
      final creditList = find.byType(ListView);

      /// Будем переключаться на евро
      final creditItem = find.widgetWithText(
        InkWell,
        'Euro Member Countries',
      );

      expect(creditList, findsOneWidget);

      /// Драгаем, пока не найдём искомый элемент
      await tester.dragUntilVisible(
        creditItem,
        creditList,
        const Offset(0, -200),
      );

      await tester.tap(creditItem);

      await tester.pumpAndSettle();

      /// Ожидаем увидеть снек с предупреждением
      expect(
        find.widgetWithText(
          SnackBar,
          AppDictionary.mainScreenSameCurrenciesSelectedWarning,
        ),
        findsOneWidget,
      );

      /// И то, что вторая валюта осталась неизменной
      expect(find.widgetWithText(ClipOval, r'$'), findsOneWidget);
    },
  );
}
