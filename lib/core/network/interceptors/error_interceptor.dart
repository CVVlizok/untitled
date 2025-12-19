import 'package:dio/dio.dart';
import '../exceptions/network_exceptions.dart';

/// Интерсептор для преобразования DioException в кастомные исключения
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _mapDioException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  NetworkException _mapDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NoConnectionException();

      case DioExceptionType.badResponse:
        return _mapStatusCode(err.response?.statusCode, err.response?.data);

      case DioExceptionType.cancel:
        return const UnknownNetworkException('Запрос был отменён');

      case DioExceptionType.badCertificate:
        return const UnknownNetworkException('Ошибка сертификата');

      case DioExceptionType.unknown:
      default:
        if (err.message?.contains('SocketException') == true ||
            err.message?.contains('Network is unreachable') == true) {
          return const NoConnectionException();
        }
        return UnknownNetworkException(err.message ?? 'Неизвестная ошибка');
    }
  }

  NetworkException _mapStatusCode(int? statusCode, dynamic data) {
    final message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(message ?? 'Некорректный запрос');
      case 401:
        return UnauthorizedException(message ?? 'Требуется авторизация');
      case 403:
        return UnauthorizedException(message ?? 'Доступ запрещён');
      case 404:
        return BadRequestException(message ?? 'Ресурс не найден');
      case 429:
        return TooManyRequestsException(
            message ?? 'Слишком много запросов. Попробуйте позже');
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(message ?? 'Ошибка сервера', statusCode);
      default:
        return UnknownNetworkException(
            message ?? 'Ошибка: статус $statusCode');
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      // NewsAPI возвращает message в поле 'message'
      if (data.containsKey('message')) {
        return data['message']?.toString();
      }
      // Другие API могут использовать 'error'
      if (data.containsKey('error')) {
        return data['error']?.toString();
      }
    }
    return null;
  }
}

