import 'package:untitled/core/models/mood_day_log.dart';
import '../../interfaces/mood_repository.dart';

class GetMoodState {
  final MoodRepository _repository;

  GetMoodState(this._repository);

  Future<MoodDayLog?> call() {
    return _repository.getTodayLog();
  }
}







