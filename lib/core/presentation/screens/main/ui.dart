import 'package:currency_exchange/core/presentation/screens/main/utils.dart';
import 'package:currency_exchange/core/presentation/screens/main/wmodel.dart';
import 'package:currency_exchange/resources/colors.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

/// Виджет главного экрана
class MainScreen extends ElementaryWidget<IMainScreenWidgetModel> {
  const MainScreen({Key? key}) : super(mainScreenWidgetModelFactory, key: key);

  @override
  Widget build(IMainScreenWidgetModel wm) {
    final debit = _CurrencyTextBox(
      textFieldState: wm.debitTextFieldState,
      hint: wm.debitHint,
      inputFormatter: wm.inputFormatter,
    );

    final credit = _CurrencyTextBox(
      textFieldState: wm.creditTextFieldState,
      hint: wm.creditHint,
      inputFormatter: wm.inputFormatter,
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(title: Text(wm.appBarTitle)),
          backgroundColor: AppColors.mainScreenBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: wm.horizontalPadding,
                vertical: wm.verticalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: wm.spacing),
                  if (orientation == Orientation.portrait)
                    Column(
                      children: [
                        debit,
                        SizedBox(height: wm.spacing),
                        credit,
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(child: debit),
                        SizedBox(width: wm.spacing),
                        Expanded(child: credit),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Элемент, представляющий текстовое поле и кнопку переключения валюты
class _CurrencyTextBox extends StatelessWidget {
  final ListenableState<EntityState<CurrencyTextFieldDto>> textFieldState;
  final TextInputFormatter inputFormatter;
  final String hint;

  const _CurrencyTextBox({
    required this.textFieldState,
    required this.hint,
    required this.inputFormatter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder<CurrencyTextFieldDto>(
      listenableEntityState: textFieldState,
      loadingBuilder: (_, state) => _buildBody(true, state),
      builder: (_, state) => _buildBody(false, state),
      errorBuilder: (_, ex, state) => _buildBody(
        false,
        state,
        ex.toString(),
      ),
    );
  }

  Widget _buildBody(
    bool isLoading,
    CurrencyTextFieldDto? state, [
    String? errorMessage,
  ]) {
    final textFieldWithButton = Stack(
      alignment: Alignment.center,
      children: [
        TextField(
          controller: state?.controller,
          enabled: !isLoading,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [inputFormatter],
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: hint,
          ),
        ),
        if (state?.currencySymbol != null)
          Positioned(
            right: 10,
            child: _RoundCurrencyButton(label: state!.currencySymbol),
          ),
      ],
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldWithButton,
        if (errorMessage != null)
          Row(
            children: [
              Text(
                errorMessage,
                style:
                    const TextStyle(color: AppColors.mainScreenErrorTextColor),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.refresh,
                color: AppColors.refreshIconColor,
              ),
            ],
          ),
      ],
    );

    return isLoading
        ? Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: body,
          )
        : body;
  }
}

/// Кнопка переключения валюты
class _RoundCurrencyButton extends StatelessWidget {
  final String label;

  const _RoundCurrencyButton({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
