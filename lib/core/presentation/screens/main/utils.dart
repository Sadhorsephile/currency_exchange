import 'package:flutter/material.dart';

/// Дата-класс, держащий в себе данные о валюте и ее введенном количестве
class CurrencyTextFieldDto {
  final TextEditingController controller;
  final String currencySymbol;

  CurrencyTextFieldDto(this.controller, this.currencySymbol);
}