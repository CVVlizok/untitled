import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'app_database.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Notes, Measurements, Profiles, WaterLogs, MoodLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
      },
    );
  }

  // Методы для работы с заметками
  Future<List<Note>> getAllNotes() => select(notes).get();
  
  Future<Note?> getNoteById(String id) {
    return (select(notes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertNote(NotesCompanion note) => into(notes).insert(note);

  Future<int> updateNote(String id, NotesCompanion note) {
    return (update(notes)..where((tbl) => tbl.id.equals(id))).write(note);
  }

  Future<int> deleteNote(String id) {
    return (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Методы для работы с измерениями
  Future<List<Measurement>> getAllMeasurements() => select(measurements).get();

  Future<List<Measurement>> getMeasurementsByType(String type) {
    return (select(measurements)..where((tbl) => tbl.type.equals(type))).get();
  }

  Future<Measurement?> getMeasurementById(String id) {
    return (select(measurements)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMeasurement(MeasurementsCompanion measurement) {
    return into(measurements).insert(measurement);
  }

  Future<int> updateMeasurement(String id, MeasurementsCompanion measurement) {
    return (update(measurements)..where((tbl) => tbl.id.equals(id))).write(measurement);
  }

  Future<int> deleteMeasurement(String id) {
    return (delete(measurements)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Методы для работы с профилями
  Future<Profile?> getProfile() {
    return select(profiles).getSingleOrNull();
  }

  Future<Profile?> getProfileById(String id) {
    return (select(profiles)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertProfile(ProfilesCompanion profile) {
    return into(profiles).insert(profile);
  }

  Future<int> updateProfile(String id, ProfilesCompanion profile) {
    return (update(profiles)..where((tbl) => tbl.id.equals(id))).write(profile);
  }

  Future<int> deleteProfile(String id) {
    return (delete(profiles)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Методы для работы с историей воды
  Future<List<WaterLog>> getAllWaterLogs() => select(waterLogs).get();

  Future<WaterLog?> getWaterLogById(String id) {
    return (select(waterLogs)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<WaterLog?> getWaterLogByDate(String date) async {
    // Нормализуем дату - берем только дату без времени
    final dateOnly = date.split('T')[0];
    final allLogs = await getAllWaterLogs();
    try {
      return allLogs.firstWhere(
        (log) {
          final logDateOnly = log.date.split('T')[0];
          return logDateOnly == dateOnly;
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<int> insertWaterLog(WaterLogsCompanion log) {
    return into(waterLogs).insert(log);
  }

  Future<int> updateWaterLog(String id, WaterLogsCompanion log) {
    return (update(waterLogs)..where((tbl) => tbl.id.equals(id))).write(log);
  }

  Future<int> deleteWaterLog(String id) {
    return (delete(waterLogs)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Методы для работы с историей настроения
  Future<List<MoodLog>> getAllMoodLogs() => select(moodLogs).get();

  Future<MoodLog?> getMoodLogById(String id) {
    return (select(moodLogs)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<MoodLog?> getMoodLogByDate(String date) async {
    // Нормализуем дату - берем только дату без времени
    final dateOnly = date.split('T')[0];
    final allLogs = await getAllMoodLogs();
    try {
      return allLogs.firstWhere(
        (log) {
          final logDateOnly = log.date.split('T')[0];
          return logDateOnly == dateOnly;
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<int> insertMoodLog(MoodLogsCompanion log) {
    return into(moodLogs).insert(log);
  }

  Future<int> updateMoodLog(String id, MoodLogsCompanion log) {
    return (update(moodLogs)..where((tbl) => tbl.id.equals(id))).write(log);
  }

  Future<int> deleteMoodLog(String id) {
    return (delete(moodLogs)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));
    return NativeDatabase(file);
  });
}

