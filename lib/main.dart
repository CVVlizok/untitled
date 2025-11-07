import 'package:flutter/material.dart';
import 'features/health/container/service_locator.dart'; // Импортируем файл с настройками GetIt
import 'features/health/container/app_router.dart'; // Импортируем роутер для навигации

void main() {
  setupLocator(); // Регистрация зависимостей в GetIt
  runApp(const MyApp()); // Запуск приложения
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
      routerConfig: appRouter, // Ссылка на конфигурацию роутера
    );
  }
}
