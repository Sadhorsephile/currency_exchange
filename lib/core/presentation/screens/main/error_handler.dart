import 'dart:developer';

import 'package:elementary/elementary.dart';

/// Обработчик ошибок для главного экрана
class MainScreenErrorHandler extends ErrorHandler {
  @override
  void handleError(Object error) {
   log(error.toString());
  }

}