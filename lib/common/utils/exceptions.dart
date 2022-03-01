/// Исключение на случай отсутствия данных для данного набора валют
class NoCurrencyCacheFoundException implements Exception {}
/// Исключение на случай невозможности подгрузить актуальные 
/// данные для данного набора валют
class OnlyCacheAvailableException implements Exception {}