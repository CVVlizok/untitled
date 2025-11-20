import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/health/container/app_router.dart';

import 'features/health/bloc/auth/login_form_cubit.dart';
import 'features/health/bloc/auth/register_form_cubit.dart';
import 'features/health/bloc/profile/profile_cubit.dart';
import 'features/health/bloc/notes/notes_cubit.dart';
import 'features/health/bloc/settings/settings_cubit.dart';
import 'features/health/bloc/measurements/measurements_cubit.dart';
import 'features/health/bloc/water/water_cubit.dart';
import 'features/health/bloc/mood/mood_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginFormCubit()),
        BlocProvider(create: (_) => RegisterFormCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => NotesCubit()),
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => MeasurementsCubit()),
        BlocProvider(create: (_) => WaterCubit()),
        BlocProvider(create: (_) => MoodCubit()),
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