import '../dto/measurement_dto.dart';

class MeasurementsLocalDataSource {
  final List<MeasurementDto> _measurements = [];

  Future<List<MeasurementDto>> getMeasurements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_measurements);
  }

  Future<List<MeasurementDto>> getMeasurementsByType(String type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _measurements.where((m) => m.type == type).toList();
  }

  Future<void> addMeasurement(MeasurementDto dto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _measurements.insert(0, dto);
  }

  Future<MeasurementDto?> removeMeasurement(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _measurements.indexWhere((m) => m.id == id);
    if (index == -1) return null;
    return _measurements.removeAt(index);
  }
}

