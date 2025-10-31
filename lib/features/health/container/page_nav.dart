// lib/features/health/container/page_nav.dart
import 'package:flutter/material.dart';
import '../models/measurement.dart';
import '../screens/profile_screen.dart';
import '../screens/parameter_picker_screen.dart';
import '../screens/measure_list_screen.dart';
import '../screens/measure_form_screen.dart';
import '../screens/notes_screen.dart';

class MeasurementsStore {
  final List<Measurement> _all = [];

  Measurement? _lastRemoved;
  int _lastRemovedIndex = -1;

  List<Measurement> byType(String type) =>
      _all.where((e) => e.type == type).toList();

  void add(Measurement m) {
    _all.add(m);
  }

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

/// Имена маршрутов
class AppRoutes {
  static const profile = '/profile';
  static const parameters = '/parameters';
  static const notes = '/notes';

  // Вертикальные маршруты внутри Parameters
  static const measureList = '/parameters/measure';
  static const measureNew = '/parameters/measure/new';
}

/// Генератор маршрутов для MaterialApp (Navigator 1.0)
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.profile:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());

    case AppRoutes.parameters:
      return MaterialPageRoute(
        builder: (ctx) => ParameterPickerScreen(
          onPick: (type) {
            Navigator.of(ctx).pushNamed(
              AppRoutes.measureList,
              arguments: type,
            );
          },
        ),
      );

    case AppRoutes.notes:
      return MaterialPageRoute(builder: (_) => const NotesScreen());

    case AppRoutes.measureList: {
      final type = settings.arguments as String;
      return MaterialPageRoute(
        builder: (ctx) => MeasureListScreen(
          title: type,
          items: measurementsStore.byType(type),
          onAddTap: () => Navigator.of(ctx).pushNamed(
            AppRoutes.measureNew,
            arguments: type,
          ),
          onRemove: (id) => measurementsStore.removeWithUndo(ctx, id),
          onBackToParams: () => Navigator.of(ctx)
              .pushReplacementNamed(AppRoutes.parameters),
        ),
      );
    }

    case AppRoutes.measureNew: {
      final type = settings.arguments as String;
      return MaterialPageRoute(
        builder: (ctx) => MeasureFormScreen(
          selectedType: type,
          onCancel: () => Navigator.of(ctx).pop(),
          onSave: (m) {
            measurementsStore.add(m);
            Navigator.of(ctx).pop(); // назад к списку
          },
        ),
      );
    }

    default:
    // fallback — на главный экран
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
  }
}
