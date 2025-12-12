import '../../interfaces/water_repository.dart';

class UpdateWaterCups {
  final WaterRepository _repository;

  UpdateWaterCups(this._repository);

  Future<void> call(int cups) {
    return _repository.updateCups(cups);
  }
}




