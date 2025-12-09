import 'package:untitled/core/models/water_day_log.dart';

abstract class WaterRepository {
  Future<WaterDayLog?> getTodayLog();
  Future<List<WaterDayLog>> getHistory();
  Future<void> updateCups(int cups);
  Future<void> saveToday();
  Future<void> updateTarget(int target);
}

