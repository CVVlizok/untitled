import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSecureDataSource {
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyPasswordHash = 'password_hash';
  static const String _keyUserLogin = 'user_login';

  final FlutterSecureStorage _storage;

  AuthSecureDataSource()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  // Сохранение токена аутентификации
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyAuthToken, value: token);
    } catch (e) {
      throw Exception('Ошибка сохранения токена: $e');
    }
  }

  // Получение токена аутентификации
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyAuthToken);
    } catch (e) {
      throw Exception('Ошибка получения токена: $e');
    }
  }

  // Удаление токена аутентификации
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyAuthToken);
    } catch (e) {
      throw Exception('Ошибка удаления токена: $e');
    }
  }

  // Сохранение refresh токена
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: refreshToken);
    } catch (e) {
      throw Exception('Ошибка сохранения refresh токена: $e');
    }
  }

  // Получение refresh токена
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (e) {
      throw Exception('Ошибка получения refresh токена: $e');
    }
  }

  // Удаление refresh токена
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: _keyRefreshToken);
    } catch (e) {
      throw Exception('Ошибка удаления refresh токена: $e');
    }
  }

  // Сохранение хэша пароля
  Future<void> savePasswordHash(String passwordHash) async {
    try {
      await _storage.write(key: _keyPasswordHash, value: passwordHash);
    } catch (e) {
      throw Exception('Ошибка сохранения хэша пароля: $e');
    }
  }

  // Получение хэша пароля
  Future<String?> getPasswordHash() async {
    try {
      return await _storage.read(key: _keyPasswordHash);
    } catch (e) {
      throw Exception('Ошибка получения хэша пароля: $e');
    }
  }

  // Удаление хэша пароля
  Future<void> deletePasswordHash() async {
    try {
      await _storage.delete(key: _keyPasswordHash);
    } catch (e) {
      throw Exception('Ошибка удаления хэша пароля: $e');
    }
  }

  // Проверка наличия токена (пользователь авторизован)
  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Сохранение логина пользователя
  Future<void> saveUserLogin(String login) async {
    try {
      await _storage.write(key: _keyUserLogin, value: login);
    } catch (e) {
      throw Exception('Ошибка сохранения логина: $e');
    }
  }

  // Получение логина пользователя
  Future<String?> getUserLogin() async {
    try {
      return await _storage.read(key: _keyUserLogin);
    } catch (e) {
      throw Exception('Ошибка получения логина: $e');
    }
  }

  // Проверка учетных данных
  Future<bool> validateCredentials(String login, String password) async {
    try {
      final savedLogin = await getUserLogin();
      final savedPasswordHash = await getPasswordHash();
      
      if (savedLogin == null || savedPasswordHash == null) {
        return false;
      }
      
      // Простая проверка (в реальном приложении нужно использовать хэширование)
      return savedLogin == login && savedPasswordHash == password;
    } catch (e) {
      return false;
    }
  }

  // Очистка всех данных аутентификации
  Future<void> clearAll() async {
    try {
      await deleteToken();
      await deleteRefreshToken();
      await deletePasswordHash();
      await _storage.delete(key: _keyUserLogin);
    } catch (e) {
      throw Exception('Ошибка очистки данных аутентификации: $e');
    }
  }
}

