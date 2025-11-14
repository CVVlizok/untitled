import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/measurement.dart';

class MeasurementsCubit extends Cubit<List<Measurement>> {
  MeasurementsCubit() : super(const []);

  void addMeasurement(Measurement m) {
    final updated = List<Measurement>.from(state)..add(m);
    emit(updated);
  }

  void removeById(String id) {
    final updated = state.where((e) => e.id != id).toList();
    emit(updated);
  }
}
