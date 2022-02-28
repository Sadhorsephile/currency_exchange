import 'package:currency_exchange/core/presentation/screens/main/wmodel.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

/// Виджет главного экрана
class MainScreen extends ElementaryWidget<MainScreenWidgetModel> {
  const MainScreen({Key? key}) : super(mainScreenWidgetModelFactory, key: key);
  @override
  Widget build(MainScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main screen'),
      ),
      body: const Center(
        child: Text('Content'),
      ),
    );
  }
}
