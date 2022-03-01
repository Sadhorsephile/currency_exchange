import 'package:currency_exchange/core/presentation/screens/main/utils.dart';
import 'package:flutter/material.dart';

/// Контент модального окна со списком доступных для конвертации валют
class SelectCurrencyModalBottomSheet extends StatelessWidget {
  final List<CurrencyInfoDto> currencies;
  final Function(CurrencyInfoDto) onSelect;

  const SelectCurrencyModalBottomSheet({
    required this.currencies,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: currencies
          .map(
            (e) => _CurrencySelectableItem(
              currency: e,
              onPressed: () {
                onSelect(e);
                Navigator.pop(context);
              },
            ),
          )
          .toList(),
    );
  }

  /// Метод открытия модального окна
  static Future<void> show(
    BuildContext context,
    List<CurrencyInfoDto> currencies,
    Function(CurrencyInfoDto) onSelect,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectCurrencyModalBottomSheet(
        currencies: currencies,
        onSelect: onSelect,
      ),
    );
  }
}

/// Карточка валюты
class _CurrencySelectableItem extends StatelessWidget {
  final CurrencyInfoDto currency;
  final VoidCallback onPressed;

  const _CurrencySelectableItem({
    required this.currency,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currency.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              currency.currencySymbol,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
