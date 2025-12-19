import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/models/water_day_log.dart';
import 'package:untitled/domain/usecases/water/get_water_state.dart';
import 'package:untitled/domain/usecases/water/get_water_history.dart';
import 'package:untitled/domain/usecases/water/update_water_cups.dart';
import 'package:untitled/domain/usecases/water/save_water_day.dart';
import 'package:untitled/domain/usecases/water/update_water_target.dart';
import 'package:untitled/domain/usecases/water/delete_water_log.dart';

class WaterState {
  final WaterDayLog? todayLog;
  final List<WaterDayLog> history;
  final bool isLoading;
  final String? error;

  const WaterState({
    this.todayLog,
    this.history = const [],
    this.isLoading = false,
    this.error,
  });

  WaterState copyWith({
    WaterDayLog? todayLog,
    List<WaterDayLog>? history,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return WaterState(
      todayLog: todayLog ?? this.todayLog,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  int get targetCups => todayLog?.targetCups ?? 8;
  int get drunkCups => todayLog?.drunkCups ?? 0;
}

class WaterCubit extends Cubit<WaterState> {
  final GetWaterState _getWaterState;
  final GetWaterHistory _getWaterHistory;
  final UpdateWaterCups _updateWaterCups;
  final SaveWaterDay _saveWaterDay;
  final UpdateWaterTarget _updateWaterTarget;
  final DeleteWaterLog _deleteWaterLog;

  WaterCubit(
    this._getWaterState,
    this._getWaterHistory,
    this._updateWaterCups,
    this._saveWaterDay,
    this._updateWaterTarget,
    this._deleteWaterLog,
  ) : super(const WaterState());

  Future<void> loadState() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final todayLog = await _getWaterState();
      final history = await _getWaterHistory();
      emit(state.copyWith(
        todayLog: todayLog,
        history: history,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> toggleCup(int index) async {
    if (index < 0 || index >= state.targetCups) return;
    final current = state.drunkCups;
    int next;
    if (index + 1 == current) {
      next = index;
    } else {
      next = index + 1;
    }
    if (next < 0) next = 0;
    if (next > state.targetCups) next = state.targetCups;

    try {
      await _updateWaterCups(next);
      await loadState();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> saveToday() async {
    try {
      await _saveWaterDay();
      await loadState();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> changeTarget(int target) async {
    if (target <= 0) return;
    try {
      await _updateWaterTarget(target);
      await loadState();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteWaterLog(String id) async {
    try {
      await _deleteWaterLog(id);
      await loadState();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
