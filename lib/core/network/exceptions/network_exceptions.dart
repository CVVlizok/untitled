/// Базовый класс для всех сетевых исключений
abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, [this.statusCode]);

  @override
  String toString() => 'NetworkException: $message (status: $statusCode)';
}

class TimeoutException extends NetworkException {
  const TimeoutException([String message = 'Превышено время ожидания'])
      : super(message);
}
class BadRequestException extends NetworkException {
  const BadRequestException([String message = 'Некорректный запрос'])
      : super(message, 400);
}
class UnauthorizedException extends NetworkException {
  const UnauthorizedException([String message = 'Требуется авторизация'])
      : super(message, 401);
}
class TooManyRequestsException extends NetworkException {
  const TooManyRequestsException(
      [String message = 'Слишком много запросов. Попробуйте позже'])
      : super(message, 429);
}
class ServerException extends NetworkException {
  const ServerException([String message = 'Ошибка сервера', int? statusCode])
      : super(message, statusCode ?? 500);
}
class NoConnectionException extends NetworkException {
  const NoConnectionException([String message = 'Нет подключения к интернету'])
      : super(message);
}
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException([String message = 'Неизвестная сетевая ошибка'])
      : super(message);
}

