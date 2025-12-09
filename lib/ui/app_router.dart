import 'package:go_router/go_router.dart';

import 'features/health/screens/profile_screen.dart';
import 'features/health/screens/parameter_picker_screen.dart';
import 'features/health/screens/measure_list_screen.dart';
import 'features/health/screens/measure_form_screen.dart';
import 'features/health/screens/notes_screen.dart';
import 'features/health/screens/login_screen.dart';
import 'features/health/screens/register_screen.dart';
import 'features/health/screens/settings_screen.dart';
import 'features/health/screens/water_screen.dart';
import 'features/health/screens/mood_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/water',
      name: 'water',
      builder: (context, state) => const WaterScreen(),
    ),
    GoRoute(
      path: '/mood',
      name: 'mood',
      builder: (context, state) => const MoodScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/notes',
      name: 'notes',
      builder: (context, state) => const NotesScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
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
