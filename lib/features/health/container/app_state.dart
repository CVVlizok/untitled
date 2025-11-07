import 'package:flutter/material.dart';
import '../models/measurement.dart';
import '../models/note_entry.dart';


class MeasurementsStore {
  final List<Measurement> _all = [];

  Measurement? _lastRemoved;
  int _lastRemovedIndex = -1;

  List<Measurement> byType(String type) =>
      _all.where((e) => e.type == type).toList(growable: false);

  void add(Measurement m) {
    _all.add(m);
  }

  bool remove(String id) {
    final idx = _all.indexWhere((e) => e.id == id);
    if (idx < 0) return false;
    _all.removeAt(idx);
    return true;
  }

  void removeWithUndo(BuildContext context, String id, VoidCallback onChanged) {
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
              onChanged();
            }
          },
        ),
      ),
    );
    onChanged();
  }
}

class NotesStore {
  final List<NoteEntry> _notes = [];

  List<NoteEntry> get all => List.unmodifiable(_notes);

  void add(NoteEntry n) {
    _notes.insert(0, n);
  }

  bool remove(String id) {
    final idx = _notes.indexWhere((e) => e.id == id);
    if (idx < 0) return false;
    _notes.removeAt(idx);
    return true;
  }
}

class AppStateScope extends InheritedWidget {
  final MeasurementsStore measurements;
  final NotesStore notes;

  final int version;

  final List<Measurement> Function(String type) measurementsByType;
  final void Function(Measurement m) addMeasurement;
  final bool Function(String id) removeMeasurement;
  final void Function(BuildContext ctx, String id) removeMeasurementWithUndo;

  final List<NoteEntry> Function() allNotes;
  final void Function(NoteEntry n) addNote;
  final bool Function(String id) removeNote;

  const AppStateScope({
    super.key,
    required this.measurements,
    required this.notes,
    required this.version,
    required this.measurementsByType,
    required this.addMeasurement,
    required this.removeMeasurement,
    required this.removeMeasurementWithUndo,
    required this.allNotes,
    required this.addNote,
    required this.removeNote,
    required super.child,
  });

  static AppStateScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(result != null, 'No AppStateScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppStateScope oldWidget) {
    return version != oldWidget.version;
  }
}

class AppStateRoot extends StatefulWidget {
  const AppStateRoot({super.key, required this.child});
  final Widget child;

  @override
  State<AppStateRoot> createState() => _AppStateRootState();
}

class _AppStateRootState extends State<AppStateRoot> {
  final _measurements = MeasurementsStore();
  final _notes = NotesStore();

  int _version = 0;
  void _bump() => setState(() => _version++);

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      measurements: _measurements,
      notes: _notes,
      version: _version,

      // ---- Фасады для экранів ----
      measurementsByType: (type) => _measurements.byType(type),

      addMeasurement: (m) {
        _measurements.add(m);
        _bump();
      },

      removeMeasurement: (id) {
        final ok = _measurements.remove(id);
        if (ok) _bump();
        return ok;
      },

      removeMeasurementWithUndo: (ctx, id) {
        _measurements.removeWithUndo(ctx, id, _bump);
      },

      allNotes: () => _notes.all,

      addNote: (n) {
        _notes.add(n);
        _bump();
      },

      removeNote: (id) {
        final ok = _notes.remove(id);
        if (ok) _bump();
        return ok;
      },

      child: widget.child,
    );
  }

  MeasurementsStore get measurements => _measurements;
  NotesStore get notes => _notes;
}
