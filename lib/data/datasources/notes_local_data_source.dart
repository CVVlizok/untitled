import '../dto/note_entry_dto.dart';

class NotesLocalDataSource {
  final List<NoteEntryDto> _notes = [];

  Future<List<NoteEntryDto>> getNotes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_notes);
  }

  Future<void> addNote(NoteEntryDto dto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notes.insert(0, dto);
  }

  Future<void> removeNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notes.removeWhere((n) => n.id == id);
  }
}



