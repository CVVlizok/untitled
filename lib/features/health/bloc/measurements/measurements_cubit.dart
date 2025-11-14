import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/measurement.dart';

class MeasurementsCubit extends Cubit<List<Measurement>> {
  MeasurementsCubit() : super(const []);

  void addMeasurement(Measurement m) {
    emit([m, ...state]);
  }

  Measurement? removeById(String id) {
    final current = List<Measurement>.from(state);
    final index = current.indexWhere((m) => m.id == id);
    if (index == -1) return null;

    final removed = current.removeAt(index);
    emit(current);
    return removed;
  }
}
