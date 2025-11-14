import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/note_entry.dart';

class NotesState {
  final List<NoteEntry> notes;

  const NotesState({this.notes = const []});

  NotesState copyWith({List<NoteEntry>? notes}) {
    return NotesState(
      notes: notes ?? this.notes,
    );
  }
}

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(const NotesState());

  void addNote(NoteEntry note) {
    final updated = List<NoteEntry>.from(state.notes)..insert(0, note);
    emit(state.copyWith(notes: updated));
  }

  void removeNote(String id) {
    final updated =
    state.notes.where((n) => n.id != id).toList(growable: false);
    emit(state.copyWith(notes: updated));
  }

  void clear() {
    emit(const NotesState(notes: []));
  }
}