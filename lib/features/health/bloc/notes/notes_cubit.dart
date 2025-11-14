// lib/features/health/bloc/notes/notes_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note_entry.dart';

class NotesCubit extends Cubit<List<NoteEntry>> {
  NotesCubit() : super([]);

  void addNote(NoteEntry note) {
    emit([note, ...state]);
  }

  void removeNote(String id) {
    emit(state.where((n) => n.id != id).toList());
  }

  void clearAll() {
    emit([]);
  }
}
