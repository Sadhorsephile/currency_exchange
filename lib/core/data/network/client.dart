import 'dart:developer';

import 'package:currency_exchange/common/utils/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart' as pp;

const _baseUrl = 'https://api.exchangerate.host';

class NetworkClient {
  static late CacheOptions _cacheOptions;

  final Dio _client;

  Dio get client => _client;

  NetworkClient(this._client) {
    _client
      ..options = BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: 5000,
      )
      ..interceptors.addAll([
        LoggerInterceptor(),
        CustomCacheInterceptor(options: _cacheOptions),
      ]);
  }

  /// Метод инициализации настроек кэширования. Обязательно должен вызываться перед стартом приложения
  static Future<void> initCacheOptions() async {
    final path = (await pp.getTemporaryDirectory()).path;
    _cacheOptions = CacheOptions(
      store: HiveCacheStore(path),
      maxStale: const Duration(days: 1),
    );
  }
}

class CustomCacheInterceptor extends DioCacheInterceptor {
  CustomCacheInterceptor({required CacheOptions options})
      : super(options: options);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final cacheOptions = _getCacheOptions(err.requestOptions);
    final cache = cacheOptions?.store;
    if (cache == null) {
      handler.reject(
        NoCurrencyCacheFoundException(
          requestOptions: err.requestOptions,
        ),
      );
    } else {
      final key = cacheOptions!.keyBuilder(err.requestOptions);
      cache.get(key).then((data) {
        if (data == null) {
          handler.reject(
            NoCurrencyCacheFoundException(
              requestOptions: err.requestOptions,
            ),
          );
        }
        handler.resolve(
          Response<dynamic>(
            requestOptions: err.requestOptions,
            data: cache.get(key),
          ),
        );
      });
    }
  }

  CacheOptions? _getCacheOptions(RequestOptions request) {
    return CacheOptions.fromExtra(request);
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(options.toString(), name: 'REQUEST OPTIONS');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(response.toString(), name: 'RESPONSE');
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log(err.toString(), name: 'ERROR');
    handler.next(err);
  }
}
