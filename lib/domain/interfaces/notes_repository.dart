import 'package:untitled/core/models/note_entry.dart';

abstract class NotesRepository {
  Future<List<NoteEntry>> getNotes();
  Future<void> addNote(NoteEntry note);
  Future<void> removeNote(String id);
}



