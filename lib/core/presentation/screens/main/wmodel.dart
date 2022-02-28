import 'package:currency_exchange/core/presentation/screens/main/model.dart';
import 'package:currency_exchange/core/presentation/screens/main/ui.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';

MainScreenWidgetModel mainScreenWidgetModelFactory(BuildContext context) => MainScreenWidgetModel(MainScreenModel());

class MainScreenWidgetModel extends WidgetModel<MainScreen, MainScreenModel> {
MainScreenWidgetModel(MainScreenModel model) : super(model);
}