/// Базовый класс для всех сетевых исключений
abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, [this.statusCode]);

  @override
  String toString() => 'NetworkException: $message (status: $statusCode)';
}

/// Таймаут соединения или получения данных
class TimeoutException extends NetworkException {
  const TimeoutException([String message = 'Превышено время ожидания'])
      : super(message);
}

/// 400 Bad Request
class BadRequestException extends NetworkException {
  const BadRequestException([String message = 'Некорректный запрос'])
      : super(message, 400);
}

/// 401 Unauthorized
class UnauthorizedException extends NetworkException {
  const UnauthorizedException([String message = 'Требуется авторизация'])
      : super(message, 401);
}

/// 429 Too Many Requests
class TooManyRequestsException extends NetworkException {
  const TooManyRequestsException(
      [String message = 'Слишком много запросов. Попробуйте позже'])
      : super(message, 429);
}

/// 5xx Server Error
class ServerException extends NetworkException {
  const ServerException([String message = 'Ошибка сервера', int? statusCode])
      : super(message, statusCode ?? 500);
}

/// Нет подключения к сети
class NoConnectionException extends NetworkException {
  const NoConnectionException([String message = 'Нет подключения к интернету'])
      : super(message);
}

/// Неизвестная ошибка
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException([String message = 'Неизвестная сетевая ошибка'])
      : super(message);
}

