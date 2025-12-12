import '../dto/note_entry_dto.dart';
import '../database/database.dart';

class NotesLocalDataSource {
  final AppDatabase _database;

  NotesLocalDataSource(this._database);

  Future<List<NoteEntryDto>> getNotes() async {
    try {
      final notes = await _database.getAllNotes();
      return notes.map((note) => NoteEntryDto(
        id: note.id,
        text: note.textContent,
        date: note.date,
      )).toList();
    } catch (e) {
      throw Exception('Ошибка получения заметок: $e');
    }
  }

  Future<void> addNote(NoteEntryDto dto) async {
    try {
      await _database.insertNote(
        NotesCompanion.insert(
          id: dto.id,
          textContent: dto.text,
          date: dto.date,
        ),
      );
    } catch (e) {
      throw Exception('Ошибка добавления заметки: $e');
    }
  }

  Future<void> removeNote(String id) async {
    try {
      await _database.deleteNote(id);
    } catch (e) {
      throw Exception('Ошибка удаления заметки: $e');
    }
  }
}




