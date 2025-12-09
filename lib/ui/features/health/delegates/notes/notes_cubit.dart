import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/note_entry.dart';
import 'package:untitled/domain/usecases/notes/get_notes.dart';
import 'package:untitled/domain/usecases/notes/add_note.dart';
import 'package:untitled/domain/usecases/notes/remove_note.dart';

class NotesState {
  final List<NoteEntry> notes;
  final bool isLoading;
  final String? error;

  const NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.error,
  });

  NotesState copyWith({
    List<NoteEntry>? notes,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class NotesCubit extends Cubit<NotesState> {
  final GetNotes _getNotes;
  final AddNote _addNote;
  final RemoveNote _removeNote;

  NotesCubit(
    this._getNotes,
    this._addNote,
    this._removeNote,
  ) : super(const NotesState());

  Future<void> loadNotes() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final notes = await _getNotes();
      emit(state.copyWith(
        notes: notes,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> addNote(NoteEntry note) async {
    try {
      await _addNote(note);
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> removeNote(String id) async {
    try {
      await _removeNote(id);
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
