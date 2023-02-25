import 'package:currency_exchange/main.dart' as app;
import 'package:currency_exchange/resources/dictionary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Тест приложения (а как ещё это назвать 🤡)',
    (tester) async {
      await app.main();
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
              w.controller?.text == '12.71',
        ),
        findsOneWidget,
      );

      /// Вводим цифру во второе поле
      await tester.enterText(creditTF, '12');

      await tester.pumpAndSettle();

      /// И ожидаем правильный результат в первом поле
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == AppDictionary.mainScreenDebitHint &&
              w.controller?.text == '11.33',
        ),
        findsOneWidget,
      );

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
              w.controller?.text == '0.15',
        ),
        findsOneWidget,
      );

      /// Нажимаем на кнопку переключения валюты второго поля
      await tester.tap(creditBtn);
      await tester.pumpAndSettle();
      final creditList = find.byType(ListView);

      /// Будем переключаться на ту же валюту, что и в первом поле
      final creditItem = find.widgetWithText(InkWell, 'Russia Ruble');

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
