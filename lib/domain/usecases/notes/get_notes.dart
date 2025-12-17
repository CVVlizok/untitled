import 'package:untitled/core/models/note_entry.dart';
import '../../interfaces/notes_repository.dart';

class GetNotes {
  final NotesRepository _repository;

  GetNotes(this._repository);

  Future<List<NoteEntry>> call() {
    return _repository.getNotes();
  }
}







