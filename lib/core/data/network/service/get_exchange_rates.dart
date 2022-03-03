import 'package:currency_exchange/common/utils/exceptions.dart';
import 'package:currency_exchange/core/data/network/client.dart';
import 'package:currency_exchange/core/data/network/models/currency.dart';

// ignore: one_member_abstracts
abstract class GetExchangeRatesApi {
  Future<CurrencyNetworkDto> call(String code);
}

class GetExchangeRatesApiImpl implements GetExchangeRatesApi {
  final NetworkClient _client;

  GetExchangeRatesApiImpl(this._client);

  @override
  Future<CurrencyNetworkDto> call(String code) async {
    final result = await _client.client.get<Map<String, dynamic>>(
      '/latest',
      queryParameters: <String, dynamic>{'base': code},
    );

    final data = result.data;

    if (data == null) {
      throw NoCurrencyCacheFoundException(
        requestOptions: result.requestOptions,
      );
    }

    return CurrencyNetworkDto.fromMap(Map<String, dynamic>.from(data));
  }
}
