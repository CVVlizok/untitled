import 'package:untitled/core/models/measurement.dart';

abstract class MeasurementsRepository {
  Future<List<Measurement>> getMeasurements();
  Future<List<Measurement>> getMeasurementsByType(String type);
  Future<void> addMeasurement(Measurement measurement);
  Future<Measurement?> removeMeasurement(String id);
}







