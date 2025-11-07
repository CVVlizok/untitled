// lib/features/health/container/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/profile_screen.dart';  // Импорт ProfileScreen
import '../screens/parameter_picker_screen.dart';  // Импорт ParameterPickerScreen
import '../screens/measure_list_screen.dart';  // Импорт MeasureListScreen
import '../screens/measure_form_screen.dart';  // Импорт MeasureFormScreen
import '../screens/notes_screen.dart';  // Импорт NotesScreen

final GoRouter appRouter = GoRouter(
  initialLocation: '/profile',
  routes: [
    GoRoute(
      path: '/notes',
      name: 'notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/parameters',
      name: 'parameters',
      builder: (context, state) => const ParameterPickerScreen(),
      routes: [
        GoRoute(
          path: 'measure/:type',  // Параметр type для типа измерений
          name: 'measure_list',
          builder: (context, state) {
            final type = state.pathParameters['type']!;  // Получаем type из path
            return MeasureListScreen(title: type);  // Передаем title в MeasureListScreen
          },
          routes: [
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
  ],
);
