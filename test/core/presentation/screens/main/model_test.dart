import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:currency_exchange/core/interactor/get_exchange_rates.dart';
import 'package:currency_exchange/core/presentation/screens/main/error_handler.dart';
import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

part 'model_test.mock.dart';

class CurrenciesUseCasesMock extends Mock implements CurrenciesUseCases {}

class ErrorHandlerMock extends Mock implements MainScreenErrorHandler {}

void main() {
  late MainScreenModel model;
  final useCases = CurrenciesUseCasesMock();
  final errorHandler = ErrorHandlerMock();

  setUp(
    () {
      model = MainScreenModel(useCases, errorHandler);

      when(() => useCases.prepopulatedCredit)
          .thenReturn(_initialCreditCurrency);
      when(() => useCases.prepopulatedDebit).thenReturn(_initialDebitCurrency);
      when(
        () => useCases.getDebitToCreditCurrencies(_initialDebitCurrency.code),
      ).thenAnswer(
        (_) async => DebitToCreditCurrenciesDto(
          _initialDebitCurrency,
          // Потому что валюты списания не может быть в списке валют зачисления
          List.from(_mockCurrencies)..remove(_initialDebitCurrency),
        ),
      );

      model.init();
    },
  );

  group(
    'MainScreenModel test:',
    () {
      test(
        'Initial data is correct',
        () async {
          await model.loadData();
          verify<void>(() =>
              useCases.getDebitToCreditCurrencies(_initialDebitCurrency.code));
          expect(model.debit, _initialDebitCurrency);
          expect(model.credit, _initialCreditCurrency);
          expect(model.currencies, _mockCurrencies);
        },
      );

      test(
        'Correctly switch credit',
        () async {
          model.switchCreditTo(_eur);
          expect(model.credit, _eur);
        },
      );

      test(
        'Correctly switch debit',
        () async {
          when(
            () => useCases.getDebitToCreditCurrencies(
              _eur.code,
            ),
          ).thenAnswer(
            (_) async => DebitToCreditCurrenciesDto(
              _eur,
              List.from(_mockCurrencies)..remove(_eur),
            ),
          );
          await model.switchDebitTo(_eur);
          expect(model.debit, _eur);
        },
      );
    },
  );
}
