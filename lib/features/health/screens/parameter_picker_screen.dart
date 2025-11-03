// lib/features/health/screens/parameter_picker_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';                  // <-- добавили
import 'package:cached_network_image/cached_network_image.dart';
class ParameterPickerScreen extends StatelessWidget {
  const ParameterPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = ['Пульс', 'Давление', 'Температура', 'Вес'];

    return Scaffold(
      appBar: AppBar(title: const Text('Параметры здоровья')),
      body: Column(
        children: [
          // Горизонтальная навигация между разделами (без истории)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pushReplacement('/profile'),
                    icon: const Icon(Icons.person),
                    label: const Text('Профиль'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushReplacement('/notes'),
                    icon: const Icon(Icons.note),
                    label: const Text('Заметки'),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              imageUrl: 'https://cdn-icons-png.flaticon.com/512/4486/4486599.png',
              progressIndicatorBuilder: (_, __, ___) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) =>
              const Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
          const SizedBox(height: 12),

          // Вертикальная навигация: список типов -> список измерений выбранного типа
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final t = items[i];
                final seg = Uri.encodeComponent(t); // на случай пробелов/кириллицы
                return ListTile(
                  leading: const Icon(Icons.health_and_safety),
                  title: Text(t),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    final seg = Uri.encodeComponent(t);
                    context.push('/parameters/measure/$seg');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
