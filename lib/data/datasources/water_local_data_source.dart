import '../dto/water_day_log_dto.dart';
import '../database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class WaterLocalDataSource {
  final AppDatabase _database;
  final _uuid = const Uuid();
  static const int _defaultTargetCups = 8;

  WaterLocalDataSource(this._database);

  String _getTodayDateString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.toIso8601String();
  }

  Future<WaterDayLogDto?> getTodayLog() async {
    try {
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getWaterLogByDate(todayDate);
      
      if (todayLog != null) {
        return WaterDayLogDto(
          id: todayLog.id,
          date: todayLog.date,
          targetCups: todayLog.targetCups,
          drunkCups: todayLog.drunkCups,
        );
      }
      return WaterDayLogDto(
        id: '',
        date: todayDate,
        targetCups: _defaultTargetCups,
        drunkCups: 0,
      );
    } catch (e) {
      throw Exception('Ошибка получения лога за сегодня: $e');
    }
  }

  Future<List<WaterDayLogDto>> getHistory() async {
    try {
      final logs = await _database.getAllWaterLogs();
      final todayDate = _getTodayDateString();
      final todayDateOnly = todayDate.split('T')[0];
      
      // Фильтруем историю: исключаем сегодняшнюю запись с нулевым значением
      // и показываем только записи с drunkCups > 0 или записи за прошлые дни
      final filteredLogs = logs.where((log) {
        final logDateOnly = log.date.split('T')[0];
        // Исключаем сегодняшнюю запись с нулевым значением
        if (logDateOnly == todayDateOnly && log.drunkCups == 0) {
          return false;
        }
        // Показываем все записи с ненулевым значением
        return log.drunkCups > 0;
      }).toList();
      
      // Сортируем по дате (новые сверху)
      filteredLogs.sort((a, b) => b.date.compareTo(a.date));
      
      return filteredLogs.map((log) => WaterDayLogDto(
        id: log.id,
        date: log.date,
        targetCups: log.targetCups,
        drunkCups: log.drunkCups,
      )).toList();
    } catch (e) {
      throw Exception('Ошибка получения истории: $e');
    }
  }

  Future<void> updateCups(int cups) async {
    try {
      if (cups < 0) cups = 0;
      
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getWaterLogByDate(todayDate);
      
      final targetCups = todayLog?.targetCups ?? _defaultTargetCups;
      if (cups > targetCups) cups = targetCups;
      
      if (todayLog != null) {
        // Обновляем существующую запись
        await _database.updateWaterLog(
          todayLog.id,
          WaterLogsCompanion(drunkCups: Value(cups)),
        );
      } else {
        // Создаем новую запись
        await _database.insertWaterLog(
          WaterLogsCompanion.insert(
            id: _uuid.v4(),
            date: todayDate,
            targetCups: targetCups,
            drunkCups: cups,
          ),
        );
      }
    } catch (e) {
      throw Exception('Ошибка обновления количества чашек: $e');
    }
  }

  Future<void> saveToday() async {
    try {
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getWaterLogByDate(todayDate);
      
      if (todayLog != null && todayLog.drunkCups > 0) {
        // Сохраняем текущее значение перед сбросом
        final savedValue = todayLog.drunkCups;
        final savedTarget = todayLog.targetCups;
        
        // Сбрасываем счетчик текущей записи для продолжения работы сегодня
        await _database.updateWaterLog(
          todayLog.id,
          WaterLogsCompanion(drunkCups: const Value(0)),
        );
        
        // Создаем новую запись с сохраненным значением для истории
        // Используем ту же дату, но с небольшим смещением времени для уникальности в базе
        // Это позволит делать несколько записей в день
        final now = DateTime.now();
        final historyDate = now.add(const Duration(milliseconds: 1)).toIso8601String();
        
        await _database.insertWaterLog(
          WaterLogsCompanion.insert(
            id: _uuid.v4(),
            date: historyDate,
            targetCups: savedTarget,
            drunkCups: savedValue,
          ),
        );
      }
      // Если записи нет или значение 0, ничего не делаем
      // Запись создастся при следующем updateCups
    } catch (e) {
      throw Exception('Ошибка сохранения дня: $e');
    }
  }

  Future<void> updateTarget(int target) async {
    try {
      if (target <= 0) return;
      
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getWaterLogByDate(todayDate);
      
      if (todayLog != null) {
        final drunkCups = todayLog.drunkCups > target ? target : todayLog.drunkCups;
        await _database.updateWaterLog(
          todayLog.id,
          WaterLogsCompanion(
            targetCups: Value(target),
            drunkCups: Value(drunkCups),
          ),
        );
      } else {
        // Создаем новую запись с новым целевым значением
        await _database.insertWaterLog(
          WaterLogsCompanion.insert(
            id: _uuid.v4(),
            date: todayDate,
            targetCups: target,
            drunkCups: 0,
          ),
        );
      }
    } catch (e) {
      throw Exception('Ошибка обновления целевого количества: $e');
    }
  }

  Future<void> deleteWaterLog(String id) async {
    try {
      await _database.deleteWaterLog(id);
    } catch (e) {
      throw Exception('Ошибка удаления записи воды: $e');
    }
  }
}




