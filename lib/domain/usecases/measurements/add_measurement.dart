import 'package:untitled/core/models/measurement.dart';
import '../../interfaces/measurements_repository.dart';

class AddMeasurement {
  final MeasurementsRepository _repository;

  AddMeasurement(this._repository);

  Future<void> call(Measurement measurement) {
    return _repository.addMeasurement(measurement);
  }
}




