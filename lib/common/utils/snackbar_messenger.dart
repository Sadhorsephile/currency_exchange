import 'package:flutter/material.dart';

/// Класс, позволяющий отображать снекбар
// ignore: one_member_abstracts
abstract class SnackBarMessenger {
  void showSnackBar(String text);
}

class SnackBarMessengerImpl implements SnackBarMessenger {
  final BuildContext context;

  SnackBarMessengerImpl(this.context);

  /// Метод, отображающий снекбар с содержимым [text]
  @override
  void showSnackBar(String text) {
    assert(ScaffoldMessenger.maybeOf(context) != null);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(text)));
      },
    );
  }
}
