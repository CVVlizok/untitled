// lib/features/health/container/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/measurement.dart';

import '../screens/profile_screen.dart';
import '../screens/parameter_picker_screen.dart';
import '../screens/measure_list_screen.dart';
import '../screens/measure_form_screen.dart';
import '../screens/notes_screen.dart';

/// Простое in-memory хранилище измерений
class MeasurementsStore {
  final List<Measurement> _all = [];

  List<Measurement> byType(String type) =>
      _all.where((e) => e.type == type).toList(growable: false);

  void add(Measurement m) => _all.add(m);
}

final measurementsStore = MeasurementsStore();

/// Глобальный роутер приложения (go_router)
final GoRouter appRouter = GoRouter(
  initialLocation: '/profile',
  routes: [
    // Профиль
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // Параметры (общий список)
    GoRoute(
      path: '/parameters',
      name: 'parameters',
      builder: (context, state) => const ParameterPickerScreen(),
      routes: [
        // Вертикально: список измерений выбранного типа
        GoRoute(
          path: 'measure/:type',
          name: 'measure_list',
          builder: (context, state) {
            final type = state.pathParameters['type']!;
            final items = measurementsStore.byType(type);
            return MeasureListScreen(
              title: type,
              items: items,
            );
          },
          routes: [
            // Вертикально: форма добавления нового измерения
            GoRoute(
              path: 'new',
              name: 'measure_new',
              builder: (context, state) {
                final type = state.pathParameters['type']!;
                return MeasureFormScreen(selectedType: type);
              },
            ),
          ],
        ),
      ],
    ),

    // Заметки
    GoRoute(
      path: '/notes',
      name: 'notes',
      builder: (context, state) => const NotesScreen(),
    ),
  ],
);
