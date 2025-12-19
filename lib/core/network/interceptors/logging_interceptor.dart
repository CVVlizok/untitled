import 'dart:developer' as developer;
import 'package:dio/dio.dart';

/// Интерсептор для логирования запросов, ответов и ошибок
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '┌────────────────────────────────────────────────────────────────────────────',
      name: 'HTTP',
    );
    developer.log(
      '│ REQUEST: ${options.method} ${options.uri}',
      name: 'HTTP',
    );
    developer.log(
      '│ Headers: ${options.headers}',
      name: 'HTTP',
    );
    if (options.data != null) {
      developer.log(
        '│ Body: ${options.data}',
        name: 'HTTP',
      );
    }
    if (options.queryParameters.isNotEmpty) {
      developer.log(
        '│ Query: ${options.queryParameters}',
        name: 'HTTP',
      );
    }
    developer.log(
      '└────────────────────────────────────────────────────────────────────────────',
      name: 'HTTP',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '┌────────────────────────────────────────────────────────────────────────────',
      name: 'HTTP',
    );
    developer.log(
      '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      name: 'HTTP',
    );
    developer.log(
      '│ Data: ${_truncateData(response.data)}',
      name: 'HTTP',
    );
    developer.log(
      '└────────────────────────────────────────────────────────────────────────────',
      name: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '┌────────────────────────────────────────────────────────────────────────────',
      name: 'HTTP ERROR',
    );
    developer.log(
      '│ ERROR: ${err.type} ${err.requestOptions.uri}',
      name: 'HTTP ERROR',
    );
    developer.log(
      '│ Message: ${err.message}',
      name: 'HTTP ERROR',
    );
    if (err.response != null) {
      developer.log(
        '│ Status: ${err.response?.statusCode}',
        name: 'HTTP ERROR',
      );
      developer.log(
        '│ Response: ${err.response?.data}',
        name: 'HTTP ERROR',
      );
    }
    developer.log(
      '└────────────────────────────────────────────────────────────────────────────',
      name: 'HTTP ERROR',
    );
    handler.next(err);
  }

  String _truncateData(dynamic data) {
    final str = data.toString();
    if (str.length > 500) {
      return '${str.substring(0, 500)}... [truncated]';
    }
    return str;
  }
}

