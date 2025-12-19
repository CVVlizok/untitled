import '../../interfaces/water_repository.dart';

class SaveWaterDay {
  final WaterRepository _repository;

  SaveWaterDay(this._repository);

  Future<void> call() {
    return _repository.saveToday();
  }
}









