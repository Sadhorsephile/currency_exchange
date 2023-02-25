import 'package:currency_exchange/core/presentation/screens/main/ext.dart';
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
      onRefreshIconPressed: wm.onRetryPressed,
      onSelectCurrencyBtnPressed: wm.openSelectDebitModalSheet,
    );

    final credit = _CurrencyTextBox(
      textFieldState: wm.creditTextFieldState,
      hint: wm.creditHint,
      inputFormatter: wm.inputFormatter,
      onRefreshIconPressed: wm.onRetryPressed,
      onSelectCurrencyBtnPressed: wm.openSelectCreditModalSheet,
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(title: Text(wm.appBarTitle)),
          backgroundColor: AppColors.mainScreenBackgroundColor,
          body: SingleChildScrollView(
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
        );
      },
    );
  }
}

/// Элемент, представляющий текстовое поле и кнопку переключения валюты
class _CurrencyTextBox extends StatelessWidget {
  final ListenableState<EntityState<CurrencyTextFieldDto>> textFieldState;
  final TextInputFormatter inputFormatter;
  final VoidCallback onRefreshIconPressed;
  final VoidCallback onSelectCurrencyBtnPressed;
  final String hint;

  const _CurrencyTextBox({
    required this.textFieldState,
    required this.hint,
    required this.inputFormatter,
    required this.onRefreshIconPressed,
    required this.onSelectCurrencyBtnPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder<CurrencyTextFieldDto>(
      listenableEntityState: textFieldState,
      loadingBuilder: (_, __) => _CurrencyTextBoxContent.loading(),
      builder: (_, state) => _CurrencyTextBoxContent.data(
        state: state,
        inputFormatter: inputFormatter,
        hint: hint,
        onSelectCurrencyBtnPressed: onSelectCurrencyBtnPressed,
      ),
      errorBuilder: (_, ex, state) => _CurrencyTextBoxContent.error(
        state: state,
        inputFormatter: inputFormatter,
        hint: hint,
        errorMessage: ex.asUserError,
        onRefreshIconPressed: onRefreshIconPressed,
        onSelectCurrencyBtnPressed: onSelectCurrencyBtnPressed,
      ),
    );
  }
}

/// Виджет, представляющий внешний вид текстового поля с кнопкой выбора валюты
class _CurrencyTextBoxContent extends StatelessWidget {
  final bool isLoading;
  final CurrencyTextFieldDto? state;
  final TextInputFormatter? inputFormatter;
  final String? hint;
  final String? errorMessage;
  final VoidCallback? onRefreshIconPressed;
  final VoidCallback? onSelectCurrencyBtnPressed;

  const _CurrencyTextBoxContent({
    required this.isLoading,
    this.inputFormatter,
    this.onRefreshIconPressed,
    this.onSelectCurrencyBtnPressed,
    this.hint,
    this.errorMessage,
    Key? key,
    this.state,
  })  : assert(isLoading || onSelectCurrencyBtnPressed != null),
        super(key: key);

  /// Текстовое поле с валютой, доступное для редактирования
  factory _CurrencyTextBoxContent.data({
    required TextInputFormatter inputFormatter,
    required VoidCallback onSelectCurrencyBtnPressed,
    CurrencyTextFieldDto? state,
    String? hint,
  }) =>
      _CurrencyTextBoxContent(
        isLoading: false,
        state: state,
        onSelectCurrencyBtnPressed: onSelectCurrencyBtnPressed,
        hint: hint,
        inputFormatter: inputFormatter,
      );

  /// Текстовое поле с валютой, не доступное для редактирования. Находится в состоянии загрузки
  factory _CurrencyTextBoxContent.loading() =>
      const _CurrencyTextBoxContent(isLoading: true);

  /// Текстовое поле с валютой, доступное для редактирования. В поле отображается ошибка [errorMessage]
  factory _CurrencyTextBoxContent.error({
    required TextInputFormatter inputFormatter,
    required String errorMessage,
    required VoidCallback onRefreshIconPressed,
    required VoidCallback onSelectCurrencyBtnPressed,
    CurrencyTextFieldDto? state,
    String? hint,
  }) =>
      _CurrencyTextBoxContent(
        isLoading: false,
        state: state,
        hint: hint,
        onSelectCurrencyBtnPressed: onSelectCurrencyBtnPressed,
        inputFormatter: inputFormatter,
        errorMessage: errorMessage,
        onRefreshIconPressed: onRefreshIconPressed,
      );

  @override
  Widget build(BuildContext context) {
    final suffixIcon = state?.currencySymbol == null || isLoading
        ? null
        : Padding(
            padding: const EdgeInsets.all(5),
            child: _RoundCurrencyButton(
              label: state!.currencySymbol,
              onPressed: onSelectCurrencyBtnPressed!,
            ),
          );

    final textFieldWithButton = TextField(
      controller: state?.controller,
      enabled: !isLoading,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [if (inputFormatter != null) inputFormatter!],
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        suffixIcon: suffixIcon,
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldWithButton,
        if (errorMessage != null)
          Row(
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: AppColors.mainScreenErrorTextColor,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: onRefreshIconPressed,
                child: const Icon(
                  Icons.refresh,
                  color: AppColors.refreshIconColor,
                ),
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
  final VoidCallback onPressed;

  const _RoundCurrencyButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            width: 35,
            height: 35,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
