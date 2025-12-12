import 'package:untitled/core/models/measurement.dart';
import '../dto/measurement_dto.dart';

extension MeasurementDtoMapper on MeasurementDto {
  Measurement toModel() {
    return Measurement(
      id: id,
      type: type,
      value: value,
      unit: unit,
      date: DateTime.parse(date),
    );
  }
}

extension MeasurementMapper on Measurement {
  MeasurementDto toDto() {
    return MeasurementDto(
      id: id,
      type: type,
      value: value,
      unit: unit,
      date: date.toIso8601String(),
    );
  }
}



