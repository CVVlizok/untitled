import '../../interfaces/mood_repository.dart';

class DeleteMoodLog {
  final MoodRepository _repository;

  DeleteMoodLog(this._repository);

  Future<void> call(String id) {
    return _repository.deleteMoodLog(id);
  }
}




