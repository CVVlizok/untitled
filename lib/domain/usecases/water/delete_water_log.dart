import '../../interfaces/water_repository.dart';

class DeleteWaterLog {
  final WaterRepository _repository;

  DeleteWaterLog(this._repository);

  Future<void> call(String id) {
    return _repository.deleteWaterLog(id);
  }
}




