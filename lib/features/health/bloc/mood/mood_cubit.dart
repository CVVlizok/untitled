import 'package:flutter_bloc/flutter_bloc.dart';

class MoodDayLog {
  final DateTime date;
  final int moodLevel; // 1..5
  final String note;

  const MoodDayLog({
    required this.date,
    required this.moodLevel,
    required this.note,
  });
}

class MoodState {
  final int? currentMood;
  final String note;
  final List<MoodDayLog> history;

  const MoodState({
    this.currentMood,
    this.note = '',
    this.history = const [],
  });

  MoodState copyWith({
    int? currentMood,
    bool clearMood = false,
    String? note,
    bool clearNote = false,
    List<MoodDayLog>? history,
  }) {
    return MoodState(
      currentMood: clearMood ? null : (currentMood ?? this.currentMood),
      note: clearNote ? '' : (note ?? this.note),
      history: history ?? this.history,
    );
  }
}

class MoodCubit extends Cubit<MoodState> {
  MoodCubit() : super(const MoodState());

  void selectMood(int level) {
    if (level < 1 || level > 5) return;
    emit(state.copyWith(currentMood: level));
  }

  void changeNote(String text) {
    emit(state.copyWith(note: text));
  }

  void saveToday() {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);

    final log = MoodDayLog(
      date: dateOnly,
      moodLevel: state.currentMood ?? 0,
      note: state.note,
    );

    final updatedHistory = List<MoodDayLog>.from(state.history)..add(log);

    emit(
      state.copyWith(
        history: updatedHistory,
        clearMood: true,
        clearNote: true,
      ),
    );
  }
}
