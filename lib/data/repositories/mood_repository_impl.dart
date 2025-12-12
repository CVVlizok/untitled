import 'package:untitled/core/models/mood_day_log.dart';
import '../../domain/interfaces/mood_repository.dart';
import '../datasources/mood_local_data_source.dart';
import '../mappers/mood_day_log_mapper.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodLocalDataSource _dataSource;

  MoodRepositoryImpl(this._dataSource);

  @override
  Future<MoodDayLog?> getTodayLog() async {
    final dto = await _dataSource.getTodayLog();
    return dto?.toModel();
  }

  @override
  Future<List<MoodDayLog>> getHistory() async {
    final dtos = await _dataSource.getHistory();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> selectMood(int level) async {
    await _dataSource.selectMood(level);
  }

  @override
  Future<void> updateNote(String note) async {
    await _dataSource.updateNote(note);
  }

  @override
  Future<void> saveToday() async {
    await _dataSource.saveToday();
  }

  @override
  Future<void> deleteMoodLog(String id) async {
    await _dataSource.deleteMoodLog(id);
  }
}




