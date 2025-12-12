import '../dto/measurement_dto.dart';
import '../database/database.dart';

class MeasurementsLocalDataSource {
  final AppDatabase _database;

  MeasurementsLocalDataSource(this._database);

  Future<List<MeasurementDto>> getMeasurements() async {
    try {
      final measurements = await _database.getAllMeasurements();
      return measurements.map((m) => MeasurementDto(
        id: m.id,
        type: m.type,
        value: m.value,
        unit: m.unit,
        date: m.date,
      )).toList();
    } catch (e) {
      throw Exception('Ошибка получения измерений: $e');
    }
  }

  Future<List<MeasurementDto>> getMeasurementsByType(String type) async {
    try {
      final measurements = await _database.getMeasurementsByType(type);
      return measurements.map((m) => MeasurementDto(
        id: m.id,
        type: m.type,
        value: m.value,
        unit: m.unit,
        date: m.date,
      )).toList();
    } catch (e) {
      throw Exception('Ошибка получения измерений по типу: $e');
    }
  }

  Future<void> addMeasurement(MeasurementDto dto) async {
    try {
      await _database.insertMeasurement(
        MeasurementsCompanion.insert(
          id: dto.id,
          type: dto.type,
          value: dto.value,
          unit: dto.unit,
          date: dto.date,
        ),
      );
    } catch (e) {
      throw Exception('Ошибка добавления измерения: $e');
    }
  }

  Future<MeasurementDto?> removeMeasurement(String id) async {
    try {
      final measurement = await _database.getMeasurementById(id);
      if (measurement == null) return null;
      
      await _database.deleteMeasurement(id);
      return MeasurementDto(
        id: measurement.id,
        type: measurement.type,
        value: measurement.value,
        unit: measurement.unit,
        date: measurement.date,
      );
    } catch (e) {
      throw Exception('Ошибка удаления измерения: $e');
    }
  }
}




