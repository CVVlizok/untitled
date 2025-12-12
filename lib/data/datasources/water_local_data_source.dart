import '../dto/water_day_log_dto.dart';

class WaterLocalDataSource {
  int _targetCups = 8;
  int _drunkCups = 0;
  final List<WaterDayLogDto> _history = [];

  Future<WaterDayLogDto?> getTodayLog() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Проверяем, есть ли запись за сегодня в истории
    final todayLog = _history.firstWhere(
      (log) {
        final logDate = DateTime.parse(log.date);
        return logDate.year == today.year &&
            logDate.month == today.month &&
            logDate.day == today.day;
      },
      orElse: () => const WaterDayLogDto(
        date: '',
        targetCups: 0,
        drunkCups: 0,
      ),
    );

    // Если есть запись за сегодня, возвращаем её
    if (todayLog.date.isNotEmpty) {
      return todayLog;
    }

    // Иначе возвращаем текущее состояние
    return WaterDayLogDto(
      date: today.toIso8601String(),
      targetCups: _targetCups,
      drunkCups: _drunkCups,
    );
  }

  Future<List<WaterDayLogDto>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_history);
  }

  Future<void> updateCups(int cups) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (cups < 0) cups = 0;
    if (cups > _targetCups) cups = _targetCups;
    _drunkCups = cups;
  }

  Future<void> saveToday() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Удаляем старую запись за сегодня, если есть
    _history.removeWhere((log) {
      final logDate = DateTime.parse(log.date);
      return logDate.year == today.year &&
          logDate.month == today.month &&
          logDate.day == today.day;
    });

    // Добавляем новую запись
    _history.insert(0, WaterDayLogDto(
      date: today.toIso8601String(),
      targetCups: _targetCups,
      drunkCups: _drunkCups,
    ));

    // Сбрасываем счетчик на сегодня
    _drunkCups = 0;
  }

  Future<void> updateTarget(int target) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (target <= 0) return;
    _targetCups = target;
    if (_drunkCups > _targetCups) {
      _drunkCups = _targetCups;
    }
  }
}



