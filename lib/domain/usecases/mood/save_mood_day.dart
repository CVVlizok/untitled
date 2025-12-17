import '../../interfaces/mood_repository.dart';

class SaveMoodDay {
  final MoodRepository _repository;

  SaveMoodDay(this._repository);

  Future<void> call() {
    return _repository.saveToday();
  }
}







