// lib/features/health/container/measurements_store.dart

import '../models/measurement.dart'; // Импортируем модель Measurement

class MeasurementsStore {
  final List<Measurement> _measurements = []; // Список для хранения всех измерений

  // Получение списка измерений по типу (например, по "Пульс", "Давление")
  List<Measurement> byType(String type) {
    return _measurements.where((measurement) => measurement.type == type).toList();
  }

  // Метод для добавления нового измерения в хранилище
  void add(Measurement measurement) {
    _measurements.add(measurement); // Добавляем измерение в список
  }

  // Метод для получения всех измерений
  List<Measurement> get all => List.unmodifiable(_measurements); // Возвращаем список всех измерений
}
