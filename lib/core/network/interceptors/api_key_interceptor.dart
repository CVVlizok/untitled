import 'package:dio/dio.dart';

/// Интерсептор для добавления API ключа NewsAPI в query параметры
class ApiKeyInterceptor extends Interceptor {
  final String apiKey;

  ApiKeyInterceptor({required this.apiKey});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Добавляем apiKey в query параметры
    options.queryParameters['apiKey'] = apiKey;
    handler.next(options);
  }
}

