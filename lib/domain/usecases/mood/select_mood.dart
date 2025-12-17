import '../../interfaces/mood_repository.dart';

class SelectMood {
  final MoodRepository _repository;

  SelectMood(this._repository);

  Future<void> call(int level) {
    return _repository.selectMood(level);
  }
}







