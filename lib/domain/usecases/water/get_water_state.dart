import 'package:untitled/core/models/water_day_log.dart';
import '../../interfaces/water_repository.dart';

class GetWaterState {
  final WaterRepository _repository;

  GetWaterState(this._repository);

  Future<WaterDayLog?> call() {
    return _repository.getTodayLog();
  }
}







