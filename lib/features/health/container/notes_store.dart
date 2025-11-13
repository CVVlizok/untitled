import '../models/note_entry.dart';

class NotesStore {
  final List<NoteEntry> _notes = [];

  List<NoteEntry> get all => List.unmodifiable(_notes);

  void add(NoteEntry note) {
    _notes.insert(0, note);
  }
}