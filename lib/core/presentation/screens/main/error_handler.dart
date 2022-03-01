import 'dart:developer';

import 'package:elementary/elementary.dart';

class MainScreenErrorHandler extends ErrorHandler {
  @override
  void handleError(Object error) {
   log(error.toString());
  }

}