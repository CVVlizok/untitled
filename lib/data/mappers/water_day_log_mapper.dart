import 'package:untitled/core/models/water_day_log.dart';
import '../dto/water_day_log_dto.dart';

extension WaterDayLogDtoMapper on WaterDayLogDto {
  WaterDayLog toModel() {
    return WaterDayLog(
      date: DateTime.parse(date),
      targetCups: targetCups,
      drunkCups: drunkCups,
    );
  }
}

extension WaterDayLogMapper on WaterDayLog {
  WaterDayLogDto toDto() {
    return WaterDayLogDto(
      date: date.toIso8601String(),
      targetCups: targetCups,
      drunkCups: drunkCups,
    );
  }
}

