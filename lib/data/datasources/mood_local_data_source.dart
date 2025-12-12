import '../dto/mood_day_log_dto.dart';
import '../database/database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class MoodLocalDataSource {
  final AppDatabase _database;
  final _uuid = const Uuid();

  MoodLocalDataSource(this._database);

  String _getTodayDateString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.toIso8601String();
  }

  Future<MoodDayLogDto?> getTodayLog() async {
    try {
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getMoodLogByDate(todayDate);
      
      if (todayLog != null) {
        return MoodDayLogDto(
          id: todayLog.id,
          date: todayLog.date,
          moodLevel: todayLog.moodLevel,
          note: todayLog.note,
        );
      }
      
      return null;
    } catch (e) {
      throw Exception('Ошибка получения лога настроения за сегодня: $e');
    }
  }

  Future<List<MoodDayLogDto>> getHistory() async {
    try {
      final logs = await _database.getAllMoodLogs();
      return logs.map((log) => MoodDayLogDto(
        id: log.id,
        date: log.date,
        moodLevel: log.moodLevel,
        note: log.note,
      )).toList();
    } catch (e) {
      throw Exception('Ошибка получения истории настроения: $e');
    }
  }

  Future<void> selectMood(int level) async {
    try {
      if (level < 1 || level > 5) return;
      
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getMoodLogByDate(todayDate);
      
      if (todayLog != null) {
        await _database.updateMoodLog(
          todayLog.id,
          MoodLogsCompanion(moodLevel: Value(level)),
        );
      } else {
        await _database.insertMoodLog(
          MoodLogsCompanion.insert(
            id: _uuid.v4(),
            date: todayDate,
            moodLevel: level,
            note: '',
          ),
        );
      }
    } catch (e) {
      throw Exception('Ошибка выбора настроения: $e');
    }
  }

  Future<void> updateNote(String note) async {
    try {
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getMoodLogByDate(todayDate);
      
      if (todayLog != null) {
        await _database.updateMoodLog(
          todayLog.id,
          MoodLogsCompanion(note: Value(note)),
        );
      } else {
        await _database.insertMoodLog(
          MoodLogsCompanion.insert(
            id: _uuid.v4(),
            date: todayDate,
            moodLevel: 0,
            note: note,
          ),
        );
      }
    } catch (e) {
      throw Exception('Ошибка обновления заметки настроения: $e');
    }
  }

  Future<void> saveToday() async {
    try {
      final todayDate = _getTodayDateString();
      final todayLog = await _database.getMoodLogByDate(todayDate);
      
      if (todayLog != null) {
        // Запись уже сохранена, ничего не делаем
        return;
      }
      
      // Если записи нет, создаем пустую запись (если нужно)
      // В данном случае просто ничего не делаем
    } catch (e) {
      throw Exception('Ошибка сохранения дня настроения: $e');
    }
  }

  Future<void> deleteMoodLog(String id) async {
    try {
      await _database.deleteMoodLog(id);
    } catch (e) {
      throw Exception('Ошибка удаления записи настроения: $e');
    }
  }
}




