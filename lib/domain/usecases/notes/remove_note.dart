import '../../interfaces/notes_repository.dart';

class RemoveNote {
  final NotesRepository _repository;

  RemoveNote(this._repository);

  Future<void> call(String id) {
    return _repository.removeNote(id);
  }
}







