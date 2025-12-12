import 'package:untitled/core/models/note_entry.dart';
import '../dto/note_entry_dto.dart';

extension NoteEntryDtoMapper on NoteEntryDto {
  NoteEntry toModel() {
    return NoteEntry(
      id: id,
      text: text,
      date: date,
    );
  }
}

extension NoteEntryMapper on NoteEntry {
  NoteEntryDto toDto() {
    return NoteEntryDto(
      id: id,
      text: text,
      date: date,
    );
  }
}



