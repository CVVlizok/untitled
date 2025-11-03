import 'package:flutter/material.dart';
import '../container/page_nav.dart'; // AppRoutes.parameters / AppRoutes.notes

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
            SizedBox(height: 16),
            SizedBox(
              width: 96,
              height: 96,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/128/10438/10438143.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 16),
            const SizedBox(height: 16),
            Row(
              children: [
                // ГОРИЗОНТАЛЬ: Профиль -> Параметры (без истории)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.parameters,
                    ),
                    icon: const Icon(Icons.monitor_heart),
                    label: const Text('Перейти к параметрам'),
                  ),
                ),
                const SizedBox(width: 12),
                // ГОРИЗОНТАЛЬ: Профиль -> Заметки (без истории)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.notes,
                    ),
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