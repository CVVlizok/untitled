import 'package:flutter/material.dart';
import '../models/measurement.dart';

class MeasureRow extends StatelessWidget {
  const MeasureRow({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final Measurement item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateStr = item.date.toLocal().toString();

    return ListTile(
      leading: const Icon(Icons.health_and_safety),
      title: Text('${item.type}: ${item.value} ${item.unit}'),
      subtitle: Text(dateStr),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
        tooltip: 'Удалить',
      ),
    );
  }
}