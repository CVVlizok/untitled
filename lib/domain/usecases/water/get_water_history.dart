import 'package:untitled/core/models/water_day_log.dart';
import '../../interfaces/water_repository.dart';

class GetWaterHistory {
  final WaterRepository _repository;

  GetWaterHistory(this._repository);

  Future<List<WaterDayLog>> call() {
    return _repository.getHistory();
  }
}



