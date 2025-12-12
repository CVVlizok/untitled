import '../dto/mood_day_log_dto.dart';

class MoodLocalDataSource {
  int? _currentMood;
  String _note = '';
  final List<MoodDayLogDto> _history = [];

  Future<MoodDayLogDto?> getTodayLog() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayLog = _history.firstWhere(
      (log) {
        final logDate = DateTime.parse(log.date);
        return logDate.year == today.year &&
            logDate.month == today.month &&
            logDate.day == today.day;
      },
      orElse: () => const MoodDayLogDto(
        date: '',
        moodLevel: 0,
        note: '',
      ),
    );
    if (todayLog.date.isNotEmpty) {
      return todayLog;
    }
    if (_currentMood != null || _note.isNotEmpty) {
      return MoodDayLogDto(
        date: today.toIso8601String(),
        moodLevel: _currentMood ?? 0,
        note: _note,
      );
    }
    return null;
  }
  Future<List<MoodDayLogDto>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_history);
  }
  Future<void> selectMood(int level) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (level < 1 || level > 5) return;
    _currentMood = level;
  }
  Future<void> updateNote(String note) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _note = note;
  }
  Future<void> saveToday() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _history.removeWhere((log) {
      final logDate = DateTime.parse(log.date);
      return logDate.year == today.year &&
          logDate.month == today.month &&
          logDate.day == today.day;
    });
    _history.insert(0, MoodDayLogDto(
      date: today.toIso8601String(),
      moodLevel: _currentMood ?? 0,
      note: _note,
    ));
    _currentMood = null;
    _note = '';
  }
}



