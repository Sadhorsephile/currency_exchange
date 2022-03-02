import 'package:flutter/material.dart';

/// Дата-класс, держащий в себе данные о валюте и ее введенном количестве
class CurrencyTextFieldDto {
  final TextEditingController controller;
  final String currencySymbol;

  CurrencyTextFieldDto(this.controller, this.currencySymbol);
}


/// Дата-класс валюты, содержающий информацию, необходимую ui
class CurrencyInfoDto {
  final String title;
  final String code;
  final String currencySymbol;

  CurrencyInfoDto(this.title, this.currencySymbol, this.code);
}

