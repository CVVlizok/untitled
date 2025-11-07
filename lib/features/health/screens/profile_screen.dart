// lib/features/health/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';            // <-- для context.pushReplacement
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: 96,
              height: 96,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/128/10438/10438143.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---- ГОРИЗОНТАЛЬНЫЕ ПЕРЕХОДЫ (без сохранения истории) ----
            Row(
              children: [
                // Профиль -> Параметры
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushReplacement('/parameters'),
                    icon: const Icon(Icons.monitor_heart),
                    label: const Text('Перейти к параметрам'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pushReplacement('/notes'),
                    icon: const Icon(Icons.note),
                    label: const Text('Перейти к заметкам'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}