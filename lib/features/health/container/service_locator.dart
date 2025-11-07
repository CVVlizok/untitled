// lib/features/health/container/service_locator.dart
import 'package:get_it/get_it.dart';
import 'measurements_store.dart';  // Импортируем MeasurementsStore
import 'notes_store.dart';  // Импортируем NotesStore
import '../models/measurement.dart'; // Модель для Measurement
import '../models/note_entry.dart'; // Модель для NoteEntry

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Регистрируем MeasurementsStore как синглтон
  locator.registerSingleton<MeasurementsStore>(MeasurementsStore());

  // Регистрируем NotesStore как синглтон
  locator.registerSingleton<NotesStore>(NotesStore());

  // Регистрируем фабрику для создания объектов типа Measurement
  locator.registerFactory<Measurement>(() => Measurement(
    id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID
    type: 'Пульс',  // Пример типа измерения
    value: '80', // Пример значения
    unit: 'уд/мин', // Пример единицы измерения
    date: DateTime.now(), // Текущее время
  ));

  // Регистрируем фабрику для создания объектов типа NoteEntry
  locator.registerFactory<NoteEntry>(() => NoteEntry(
    id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID
    text: 'Пример заметки', // Текст заметки
    date: DateTime.now().toIso8601String(), // Текущая дата в формате ISO 8601
  ));
}
