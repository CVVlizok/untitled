import 'package:flutter/material.dart';
import '../models/measurement.dart';

/// ========
/// Маршруты
/// ========
class AppRoutes {
  static const profile     = '/';                    // было '/profile'
  static const parameters  = '/parameters';
  static const measureList = '/parameters/measure';
  static const measureNew  = '/parameters/measure/new';
  static const notes       = '/notes';
}

/// ========================
/// Локальное хранилище данных
/// ========================
class MeasurementsStore {
  final List<Measurement> _all = [];
  Measurement? _lastRemoved;
  int _lastRemovedIndex = -1;

  /// Получить все измерения по типу (Пульс, Давление и т.д.)
  List<Measurement> byType(String type) =>
      _all.where((e) => e.type == type).toList(growable: false);

  /// Добавить новое измерение
  void add(Measurement m) => _all.add(m);

  /// Удалить с возможностью отмены
  void removeWithUndo(BuildContext context, String id) {
    final idx = _all.indexWhere((e) => e.id == id);
    if (idx < 0) return;

    _lastRemoved = _all.removeAt(idx);
    _lastRemovedIndex = idx;

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Измерение удалено'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            if (_lastRemoved != null && _lastRemovedIndex >= 0) {
              _all.insert(_lastRemovedIndex, _lastRemoved!);
              _lastRemoved = null;
              _lastRemovedIndex = -1;
            }
          },
        ),
      ),
    );
  }
}

final measurementsStore = MeasurementsStore();
