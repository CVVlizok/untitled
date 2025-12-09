import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/measurement.dart';
import 'package:untitled/domain/usecases/measurements/get_measurements.dart';
import 'package:untitled/domain/usecases/measurements/get_measurements_by_type.dart';
import 'package:untitled/domain/usecases/measurements/add_measurement.dart';
import 'package:untitled/domain/usecases/measurements/remove_measurement.dart';

class MeasurementsState {
  final List<Measurement> measurements;
  final bool isLoading;
  final String? error;

  const MeasurementsState({
    this.measurements = const [],
    this.isLoading = false,
    this.error,
  });

  MeasurementsState copyWith({
    List<Measurement>? measurements,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MeasurementsState(
      measurements: measurements ?? this.measurements,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MeasurementsCubit extends Cubit<MeasurementsState> {
  final GetMeasurements _getMeasurements;
  final GetMeasurementsByType _getMeasurementsByType;
  final AddMeasurement _addMeasurement;
  final RemoveMeasurement _removeMeasurement;

  MeasurementsCubit(
    this._getMeasurements,
    this._getMeasurementsByType,
    this._addMeasurement,
    this._removeMeasurement,
  ) : super(const MeasurementsState());

  Future<void> loadMeasurements() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final measurements = await _getMeasurements();
      emit(state.copyWith(
        measurements: measurements,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadMeasurementsByType(String type) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final measurements = await _getMeasurementsByType(type);
      emit(state.copyWith(
        measurements: measurements,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> addMeasurement(Measurement measurement) async {
    try {
      await _addMeasurement(measurement);
      await loadMeasurements();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> removeMeasurement(String id) async {
    try {
      await _removeMeasurement(id);
      await loadMeasurements();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
