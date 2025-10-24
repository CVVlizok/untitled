import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ParameterPickerScreen extends StatelessWidget {
  const ParameterPickerScreen({
    super.key,
    required this.onPick,
  });

  final void Function(String type) onPick;

  @override
  Widget build(BuildContext context) {
    const items = ['Пульс', 'Давление', 'Температура', 'Вес'];
    return Scaffold(
      appBar: AppBar(title: const Text('Параметры здоровья')),
      body: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              imageUrl:
              'https://cdn-icons-png.flaticon.com/512/4486/4486599.png',
              progressIndicatorBuilder: (context, url, progress) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
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
          ),
        ],
      ),
    );
  }
}