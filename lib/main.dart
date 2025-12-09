import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'ui/app_router.dart';

import 'ui/features/health/delegates/auth/login_form_cubit.dart';
import 'ui/features/health/delegates/auth/register_form_cubit.dart';
import 'ui/features/health/delegates/profile/profile_cubit.dart';
import 'ui/features/health/delegates/notes/notes_cubit.dart';
import 'ui/features/health/delegates/settings/settings_cubit.dart';
import 'ui/features/health/delegates/measurements/measurements_cubit.dart';
import 'ui/features/health/delegates/water/water_cubit.dart';
import 'ui/features/health/delegates/mood/mood_cubit.dart';

void main() {
  // Инициализация Dependency Injection
  setupDependencyInjection();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginFormCubit>()),
        BlocProvider(create: (_) => getIt<RegisterFormCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<NotesCubit>()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => getIt<MeasurementsCubit>()),
        BlocProvider(create: (_) => getIt<WaterCubit>()),
        BlocProvider(create: (_) => getIt<MoodCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Практика Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
