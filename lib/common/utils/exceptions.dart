import 'package:dio/dio.dart';

/// Исключение на случай отсутствия данных для данного набора валют
class NoCurrencyCacheFoundException extends DioError {
  NoCurrencyCacheFoundException({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}

/// Исключение на случай невозможности подгрузить актуальные
/// данные для данного набора валют
class OnlyCacheAvailableException extends DioError {
  OnlyCacheAvailableException({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}
