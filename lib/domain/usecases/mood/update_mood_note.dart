import '../../interfaces/mood_repository.dart';

class UpdateMoodNote {
  final MoodRepository _repository;

  UpdateMoodNote(this._repository);

  Future<void> call(String note) {
    return _repository.updateNote(note);
  }
}



