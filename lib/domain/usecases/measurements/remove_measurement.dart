import '../../interfaces/measurements_repository.dart';

class RemoveMeasurement {
  final MeasurementsRepository _repository;

  RemoveMeasurement(this._repository);

  Future<void> call(String id) {
    return _repository.removeMeasurement(id);
  }
}



