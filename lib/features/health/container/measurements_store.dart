import 'package:flutter/material.dart';
import '../models/measurement.dart';

class MeasurementsStore {
  final List<Measurement> _all = [];

  Measurement? _lastRemoved;
  int _lastRemovedIndex = -1;

  /// Получить список измерений по типу
  List<Measurement> byType(String type) =>
      _all.where((m) => m.type == type).toList(growable: false);

  /// Добавить новое измерение
  void add(Measurement m, {VoidCallback? onChange}) {
    _all.add(m);
    onChange?.call();
  }

  /// Удаление измерения с возможностью отмены через SnackBar
  void removeWithUndo(
      BuildContext context,
      String id, {
        VoidCallback? onChange,
      }) {
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
              onChange?.call();
            }
          },
        ),
      ),
    );

    onChange?.call();
  }
}
