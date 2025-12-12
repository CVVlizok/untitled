import 'package:untitled/core/models/measurement.dart';
import '../../interfaces/measurements_repository.dart';

class GetMeasurements {
  final MeasurementsRepository _repository;

  GetMeasurements(this._repository);

  Future<List<Measurement>> call() {
    return _repository.getMeasurements();
  }
}




