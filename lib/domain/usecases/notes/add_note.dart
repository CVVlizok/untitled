import 'package:untitled/core/models/note_entry.dart';
import '../../interfaces/notes_repository.dart';

class AddNote {
  final NotesRepository _repository;

  AddNote(this._repository);

  Future<void> call(NoteEntry note) {
    return _repository.addNote(note);
  }
}







