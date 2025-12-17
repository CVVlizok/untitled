import 'package:untitled/core/models/note_entry.dart';
import '../../domain/interfaces/notes_repository.dart';
import '../datasources/notes_local_data_source.dart';
import '../mappers/note_entry_mapper.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource _dataSource;

  NotesRepositoryImpl(this._dataSource);

  @override
  Future<List<NoteEntry>> getNotes() async {
    final dtos = await _dataSource.getNotes();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> addNote(NoteEntry note) async {
    final dto = note.toDto();
    await _dataSource.addNote(dto);
  }

  @override
  Future<void> removeNote(String id) async {
    await _dataSource.removeNote(id);
  }
}







