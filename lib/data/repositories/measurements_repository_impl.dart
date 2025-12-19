import 'package:untitled/core/models/measurement.dart';
import '../../domain/interfaces/measurements_repository.dart';
import '../datasources/measurements_local_data_source.dart';
import '../mappers/measurement_mapper.dart';

class MeasurementsRepositoryImpl implements MeasurementsRepository {
  final MeasurementsLocalDataSource _dataSource;

  MeasurementsRepositoryImpl(this._dataSource);

  @override
  Future<List<Measurement>> getMeasurements() async {
    final dtos = await _dataSource.getMeasurements();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<List<Measurement>> getMeasurementsByType(String type) async {
    final dtos = await _dataSource.getMeasurementsByType(type);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> addMeasurement(Measurement measurement) async {
    final dto = measurement.toDto();
    await _dataSource.addMeasurement(dto);
  }

  @override
  Future<Measurement?> removeMeasurement(String id) async {
    final dto = await _dataSource.removeMeasurement(id);
    return dto?.toModel();
  }
}









