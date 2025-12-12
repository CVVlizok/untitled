import 'package:untitled/core/models/mood_day_log.dart';
import '../../interfaces/mood_repository.dart';

class GetMoodHistory {
  final MoodRepository _repository;

  GetMoodHistory(this._repository);

  Future<List<MoodDayLog>> call() {
    return _repository.getHistory();
  }
}




