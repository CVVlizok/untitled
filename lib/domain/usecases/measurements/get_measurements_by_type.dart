import 'package:untitled/core/models/measurement.dart';
import '../../interfaces/measurements_repository.dart';

class GetMeasurementsByType {
  final MeasurementsRepository _repository;

  GetMeasurementsByType(this._repository);

  Future<List<Measurement>> call(String type) {
    return _repository.getMeasurementsByType(type);
  }
}

