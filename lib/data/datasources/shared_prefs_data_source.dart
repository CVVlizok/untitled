import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsDataSource {
  static const String _keyThemeDark = 'theme_dark';
  static const String _keyLanguage = 'language';

  // Сохранение булевого значения
  Future<bool> saveBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(key, value);
    } catch (e) {
      throw Exception('Ошибка сохранения булевого значения: $e');
    }
  }

  // Получение булевого значения
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key);
    } catch (e) {
      throw Exception('Ошибка получения булевого значения: $e');
    }
  }

  // Сохранение строкового значения
  Future<bool> saveString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(key, value);
    } catch (e) {
      throw Exception('Ошибка сохранения строкового значения: $e');
    }
  }

  // Получение строкового значения
  Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      throw Exception('Ошибка получения строкового значения: $e');
    }
  }

  // Сохранение целого числа
  Future<bool> saveInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(key, value);
    } catch (e) {
      throw Exception('Ошибка сохранения целого числа: $e');
    }
  }

  // Получение целого числа
  Future<int?> getInt(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    } catch (e) {
      throw Exception('Ошибка получения целого числа: $e');
    }
  }

  // Удаление значения по ключу
  Future<bool> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e) {
      throw Exception('Ошибка удаления значения: $e');
    }
  }

  // Очистка всех данных
  Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      throw Exception('Ошибка очистки данных: $e');
    }
  }

  // Специфичные методы для темы
  Future<bool> saveThemeDark(bool isDark) async {
    return await saveBool(_keyThemeDark, isDark);
  }

  Future<bool?> getThemeDark() async {
    return await getBool(_keyThemeDark);
  }

  // Специфичные методы для языка
  Future<bool> saveLanguage(String lang) async {
    return await saveString(_keyLanguage, lang);
  }

  Future<String?> getLanguage() async {
    return await getString(_keyLanguage);
  }
}

