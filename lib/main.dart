import 'package:flutter/material.dart';

// Маршруты и стор
import 'features/health/container/page_nav.dart';

// Экраны
import 'features/health/screens/profile_screen.dart';
import 'features/health/screens/parameter_picker_screen.dart';
import 'features/health/screens/measure_list_screen.dart';
import 'features/health/screens/measure_form_screen.dart';
import 'features/health/screens/notes_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Практика Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.profile, // теперь это '/'
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.profile:
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case AppRoutes.parameters:
            return MaterialPageRoute(builder: (_) => const ParameterPickerScreen());
          case AppRoutes.measureList:
            final type = settings.arguments as String;
            final items = measurementsStore.byType(type);
            return MaterialPageRoute(builder: (_) => MeasureListScreen(title: type, items: items));
          case AppRoutes.measureNew:
            final type = settings.arguments as String;
            return MaterialPageRoute(builder: (_) => MeasureFormScreen(selectedType: type));
          case AppRoutes.notes:
            return MaterialPageRoute(builder: (_) => const NotesScreen());

          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Страница не найдена')),
              ),
            );
        }
      },
    );
  }
}
