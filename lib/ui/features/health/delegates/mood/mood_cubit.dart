import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/mood_day_log.dart';
import 'package:untitled/domain/usecases/mood/get_mood_state.dart';
import 'package:untitled/domain/usecases/mood/get_mood_history.dart';
import 'package:untitled/domain/usecases/mood/select_mood.dart';
import 'package:untitled/domain/usecases/mood/update_mood_note.dart';
import 'package:untitled/domain/usecases/mood/save_mood_day.dart';
import 'package:untitled/domain/usecases/mood/delete_mood_log.dart';

class MoodState {
  final MoodDayLog? todayLog;
  final List<MoodDayLog> history;
  final int? currentMood;
  final String note;
  final bool isLoading;
  final String? error;

  const MoodState({
    this.todayLog,
    this.history = const [],
    this.currentMood,
    this.note = '',
    this.isLoading = false,
    this.error,
  });

  MoodState copyWith({
    MoodDayLog? todayLog,
    List<MoodDayLog>? history,
    int? currentMood,
    bool clearMood = false,
    String? note,
    bool clearNote = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MoodState(
      todayLog: todayLog ?? this.todayLog,
      history: history ?? this.history,
      currentMood: clearMood ? null : (currentMood ?? this.currentMood),
      note: clearNote ? '' : (note ?? this.note),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MoodCubit extends Cubit<MoodState> {
  final GetMoodState _getMoodState;
  final GetMoodHistory _getMoodHistory;
  final SelectMood _selectMood;
  final UpdateMoodNote _updateMoodNote;
  final SaveMoodDay _saveMoodDay;
  final DeleteMoodLog _deleteMoodLog;

  MoodCubit(
    this._getMoodState,
    this._getMoodHistory,
    this._selectMood,
    this._updateMoodNote,
    this._saveMoodDay,
    this._deleteMoodLog,
  ) : super(const MoodState());

  Future<void> loadState() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final todayLog = await _getMoodState();
      final history = await _getMoodHistory();
      
      int? currentMood;
      String note = '';
      if (todayLog != null) {
        currentMood = todayLog.moodLevel > 0 ? todayLog.moodLevel : null;
        note = todayLog.note;
      }

      emit(state.copyWith(
        todayLog: todayLog,
        history: history,
        currentMood: currentMood,
        note: note,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> selectMood(int level) async {
    if (level < 1 || level > 5) return;
    try {
      await _selectMood(level);
      emit(state.copyWith(currentMood: level));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> changeNote(String text) async {
    try {
      await _updateMoodNote(text);
      emit(state.copyWith(note: text));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> saveToday() async {
    try {
      await _saveMoodDay();
      
      // Загружаем только историю, не трогая текущее состояние
      final history = await _getMoodHistory();
      
      // Очищаем текущее состояние после сохранения и обновляем историю
      emit(state.copyWith(
        history: history,
        currentMood: null,
        clearMood: true,
        note: '',
        clearNote: true,
        todayLog: null, // Очищаем запись за сегодня
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteMoodLog(String id) async {
    try {
      await _deleteMoodLog(id);
      await loadState();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
