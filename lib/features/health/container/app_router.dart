import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/measurement.dart';

import '../screens/home_shell.dart';
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
      _all.where((e) => e.type == type).toList(growable: false);

  void add(Measurement m) => _all.add(m);

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

final GoRouter appRouter = GoRouter(
  initialLocation: '/profile',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/profile',
    ),

    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        // Профиль
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),

        GoRoute(
          path: '/parameters',
          name: 'parameters',
          pageBuilder: (context, state) => NoTransitionPage(
            child: ParameterPickerScreen(
              onPick: (type) => context.push('/parameters/measure/$type'),
            ),
          ),
          routes: [
            // Список измерений выбранного типа
            GoRoute(
              path: 'measure/:type',
              name: 'measure_list',
              builder: (context, state) {
                final type = state.pathParameters['type']!;
                final items = measurementsStore.byType(type);
                return MeasureListScreen(
                  title: type,
                  items: items,
                  onAddTap: () async {
                    final result = await context.push<Measurement>(
                      '/parameters/measure/$type/new',
                    );
                    if (result != null) {
                      measurementsStore.add(result);
                    }
                  },
                  onRemove: (id) =>
                      measurementsStore.removeWithUndo(context, id),
                  onBackToParams: () => context.go('/parameters'),
                );
              },
            ),

            GoRoute(
              path: 'measure/:type/new',
              name: 'measure_new',
              builder: (context, state) {
                final type = state.pathParameters['type']!;
                // Важно: никаких onCancel/onSave — экран сам делает pop(result)
                return MeasureFormScreen(selectedType: type);
              },
            ),
          ],
        ),

        GoRoute(
          path: '/notes',
          name: 'notes',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NotesScreen(),
          ),
        ),
      ],
    ),
  ],
);