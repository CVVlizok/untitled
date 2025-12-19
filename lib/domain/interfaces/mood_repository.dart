import 'package:untitled/core/models/mood_day_log.dart';

abstract class MoodRepository {
  Future<MoodDayLog?> getTodayLog();
  Future<List<MoodDayLog>> getHistory();
  Future<void> selectMood(int level);
  Future<void> updateNote(String note);
  Future<void> saveToday();
  Future<void> deleteMoodLog(String id);
}




