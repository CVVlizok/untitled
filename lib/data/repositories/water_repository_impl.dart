import 'package:untitled/core/models/water_day_log.dart';
import '../../domain/interfaces/water_repository.dart';
import '../datasources/water_local_data_source.dart';
import '../mappers/water_day_log_mapper.dart';

class WaterRepositoryImpl implements WaterRepository {
  final WaterLocalDataSource _dataSource;

  WaterRepositoryImpl(this._dataSource);

  @override
  Future<WaterDayLog?> getTodayLog() async {
    final dto = await _dataSource.getTodayLog();
    return dto?.toModel();
  }

  @override
  Future<List<WaterDayLog>> getHistory() async {
    final dtos = await _dataSource.getHistory();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> updateCups(int cups) async {
    await _dataSource.updateCups(cups);
  }

  @override
  Future<void> saveToday() async {
    await _dataSource.saveToday();
  }

  @override
  Future<void> updateTarget(int target) async {
    await _dataSource.updateTarget(target);
  }

  @override
  Future<void> deleteWaterLog(String id) async {
    await _dataSource.deleteWaterLog(id);
  }
}




