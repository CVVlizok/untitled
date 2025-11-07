import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/measurement.dart';
import '../screens/profile_screen.dart';
import '../screens/parameter_picker_screen.dart';
import '../screens/measure_list_screen.dart';
import '../screens/measure_form_screen.dart';
import '../screens/notes_screen.dart';

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
          path: 'measure/:type',
          name: 'measure_list',
          builder: (context, state) {
            final type = state.pathParameters['type']!;
            return MeasureListScreen(title: type);
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
