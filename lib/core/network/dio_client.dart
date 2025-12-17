import 'package:dio/dio.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/api_key_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Конфигурация для NewsAPI
class NewsApiConfig {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'af13796dffcb4a6d8042a6e88c835c18';
}

/// Конфигурация для OpenAlex API
class OpenAlexConfig {
  static const String baseUrl = 'https://api.openalex.org';
}

/// Фабрика для создания Dio клиентов
class DioClient {
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  /// Создаёт Dio клиент для NewsAPI с ApiKeyInterceptor
  static Dio createNewsApiClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NewsApiConfig.baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      ApiKeyInterceptor(apiKey: NewsApiConfig.apiKey),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }

  /// Создаёт Dio клиент для OpenAlex API (публичный, без ключа)
  static Dio createOpenAlexClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: OpenAlexConfig.baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}

