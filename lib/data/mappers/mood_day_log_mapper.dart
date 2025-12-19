import 'package:untitled/core/models/mood_day_log.dart';
import '../dto/mood_day_log_dto.dart';

extension MoodDayLogDtoMapper on MoodDayLogDto {
  MoodDayLog toModel() {
    return MoodDayLog(
      id: id,
      date: DateTime.parse(date),
      moodLevel: moodLevel,
      note: note,
    );
  }
}

extension MoodDayLogMapper on MoodDayLog {
  MoodDayLogDto toDto() {
    return MoodDayLogDto(
      id: id,
      date: date.toIso8601String(),
      moodLevel: moodLevel,
      note: note,
    );
  }
}




