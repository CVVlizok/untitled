import '../../interfaces/water_repository.dart';

class UpdateWaterTarget {
  final WaterRepository _repository;

  UpdateWaterTarget(this._repository);

  Future<void> call(int target) {
    return _repository.updateTarget(target);
  }
}









