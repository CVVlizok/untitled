import 'package:drift/drift.dart';

// Таблица для заметок
class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get textContent => text()();
  TextColumn get date => text()(); // YYYY-MM-DD

  @override
  Set<Column> get primaryKey => {id};
}

// Таблица для измерений
class Measurements extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get value => text()();
  TextColumn get unit => text()();
  TextColumn get date => text()(); // ISO 8601 format

  @override
  Set<Column> get primaryKey => {id};
}

// Таблица для профилей
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get login => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// Таблица для истории воды
class WaterLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()(); // ISO 8601 format
  IntColumn get targetCups => integer()();
  IntColumn get drunkCups => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// Таблица для истории настроения
class MoodLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()(); // ISO 8601 format
  IntColumn get moodLevel => integer()(); // 1..5
  TextColumn get note => text()();

  @override
  Set<Column> get primaryKey => {id};
}

