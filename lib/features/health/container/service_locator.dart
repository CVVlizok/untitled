// lib/features/health/container/service_locator.dart
import 'package:get_it/get_it.dart';
import 'measurements_store.dart';
import 'notes_store.dart';
import '../models/measurement.dart';
import '../models/note_entry.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<MeasurementsStore>(MeasurementsStore());

  locator.registerSingleton<NotesStore>(NotesStore());

  locator.registerFactory<Measurement>(() => Measurement(
    id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID
    type: 'Пульс',  // Пример типа измерения
    value: '80', // Пример значения
    unit: 'уд/мин', // Пример единицы измерения
    date: DateTime.now(), // Текущее время
  ));

  locator.registerFactory<NoteEntry>(() => NoteEntry(
    id: DateTime.now().millisecondsSinceEpoch.toString(), // Уникальный ID
    text: 'Пример заметки', // Текст заметки
    date: DateTime.now().toIso8601String(), // Текущая дата в формате ISO 8601
  ));
}