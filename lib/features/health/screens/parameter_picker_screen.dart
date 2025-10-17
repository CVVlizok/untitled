import 'package:flutter/material.dart';

class ParameterPickerScreen extends StatelessWidget {
  const ParameterPickerScreen({
    super.key,
    required this.onPick,
  });

  final void Function(String type) onPick;

  @override
  Widget build(BuildContext context) {
    final items = const ['Пульс', 'Давление', 'Температура', 'Вес'];

    return Scaffold(
      appBar: AppBar(title: const Text('Параметры здоровья')),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final t = items[i];
          return ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: Text(t),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onPick(t),
          );
        },
      ),
    );
  }
}
