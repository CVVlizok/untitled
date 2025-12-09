import 'package:flutter_bloc/flutter_bloc.dart';

class WaterDayLog {
  final DateTime date;
  final int targetCups;
  final int drunkCups;

  const WaterDayLog({
    required this.date,
    required this.targetCups,
    required this.drunkCups,
  });
}

class WaterState {
  final int targetCups;
  final int drunkCups;
  final List<WaterDayLog> history;

  const WaterState({
    this.targetCups = 8,
    this.drunkCups = 0,
    this.history = const [],
  });

  WaterState copyWith({
    int? targetCups,
    int? drunkCups,
    List<WaterDayLog>? history,
  }) {
    return WaterState(
      targetCups: targetCups ?? this.targetCups,
      drunkCups: drunkCups ?? this.drunkCups,
      history: history ?? this.history,
    );
  }
}

class WaterCubit extends Cubit<WaterState> {
  WaterCubit() : super(const WaterState());

  void toggleCup(int index) {
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

    emit(state.copyWith(drunkCups: next));
  }
  void saveToday() {
    final now = DateTime.now();
    final dateOnly = DateTime(now.year, now.month, now.day);
    final log = WaterDayLog(
      date: dateOnly,
      targetCups: state.targetCups,
      drunkCups: state.drunkCups,
    );
    final updatedHistory = List<WaterDayLog>.from(state.history)
      ..add(log);
    emit(
      state.copyWith(
        history: updatedHistory,
        drunkCups: 0,
      ),
    );
  }
  void changeTarget(int target) {
    if (target <= 0) return;
    int newDrunk = state.drunkCups;
    if (newDrunk > target) {
      newDrunk = target;
    }
    emit(
      state.copyWith(
        targetCups: target,
        drunkCups: newDrunk,
      ),
    );
  }
}
