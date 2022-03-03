import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:currency_exchange/core/domain/entities/currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Контент модального окна со списком доступных для конвертации валют
class SelectCurrencyModalBottomSheet extends StatelessWidget {
  final ValueListenable<List<CurrencyDto>> currencies;
  final Function(CurrencyDto) onSelect;
  final ScrollController scrollController;

  const SelectCurrencyModalBottomSheet({
    required this.currencies,
    required this.onSelect,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CurrencyDto>>(
      valueListenable: currencies,
      builder: (context, data,_) {
        return ListView(
          controller: scrollController,
          children: data
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
      },
    );
  }

  /// Метод открытия модального окна
  static Future<void> show(
    BuildContext context,
    ValueListenable<List<CurrencyDto>> currencies,
    Function(CurrencyDto) onSelect,
  ) {
    return showFlexibleBottomSheet(
      context: context,
      initHeight: 0.8,
      maxHeight: 0.8,
      builder: (_, scrollController, __) => SelectCurrencyModalBottomSheet(
        currencies: currencies,
        onSelect: onSelect,
        scrollController: scrollController,
      ),
    );
  }
}

/// Карточка валюты
class _CurrencySelectableItem extends StatelessWidget {
  final CurrencyDto currency;
  final VoidCallback onPressed;

  const _CurrencySelectableItem({
    required this.currency,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
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
              Expanded(
                child: Text(
                  currency.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                currency.symbol,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
