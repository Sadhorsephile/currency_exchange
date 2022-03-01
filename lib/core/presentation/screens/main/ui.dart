import 'package:currency_exchange/core/presentation/screens/main/wmodel.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

/// Виджет главного экрана
class MainScreen extends ElementaryWidget<IMainScreenWidgetModel> {
  const MainScreen({Key? key}) : super(mainScreenWidgetModelFactory, key: key);

  @override
  Widget build(IMainScreenWidgetModel wm) {
    final uiProperties = wm.uiElementsProperties;

    final debit = _CurrencyTextBox(
      textFieldState: wm.debitTextFieldState,
      uiProperties: uiProperties,
      hint: uiProperties.debitHint,
      inputFormatter: wm.inputFormatter,
      onRefreshIconPressed: wm.onRetryPressed,
    );

    final credit = _CurrencyTextBox(
      textFieldState: wm.creditTextFieldState,
      uiProperties: uiProperties,
      hint: uiProperties.creditHint,
      inputFormatter: wm.inputFormatter,
      onRefreshIconPressed: wm.onRetryPressed,
    );

    return Scaffold(
      appBar: AppBar(title: Text(uiProperties.appBarTitle)),
      backgroundColor: uiProperties.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: uiProperties.horizontalPadding,
            vertical: uiProperties.verticalPadding,
          ),
          child: Column(
            children: [
              SizedBox(height: uiProperties.spacing),
              if (wm.orientation == Orientation.portrait)
                Column(
                  children: [
                    debit,
                    SizedBox(height: uiProperties.spacing),
                    credit,
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(child: debit),
                    SizedBox(width: uiProperties.spacing),
                    Expanded(child: credit),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Элемент, представляющий текстовое поле и кнопку переключения валюты
class _CurrencyTextBox extends StatelessWidget {
  final ListenableState<EntityState<CurrencyTextFieldDto>> textFieldState;
  final UiElementsProperties uiProperties;
  final TextInputFormatter inputFormatter;
  final VoidCallback onRefreshIconPressed;
  final String hint;

  const _CurrencyTextBox({
    required this.textFieldState,
    required this.hint,
    required this.uiProperties,
    required this.inputFormatter,
    required this.onRefreshIconPressed,
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
          decoration: uiProperties.textFieldDecoration.copyWith(hintText: hint),
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
                style: TextStyle(color: uiProperties.errorTextColor),
              ),
              SizedBox(width: uiProperties.spacing),
              GestureDetector(
                onTap: onRefreshIconPressed,
                child: Icon(
                  Icons.refresh,
                  color: uiProperties.refreshIconColor,
                ),
              ),
            ],
          ),
      ],
    );

    return isLoading
        ? Shimmer.fromColors(
            baseColor: uiProperties.shimmerBaseColor,
            highlightColor: uiProperties.shimmerHighlightColor,
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
