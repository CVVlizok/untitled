import 'package:flutter/material.dart';
import '../models/measurement.dart';
import '../widgets/measure_row.dart';

class MeasureListScreen extends StatelessWidget {
  const MeasureListScreen({
    super.key,
    required this.items,
    required this.onAddTap,
    required this.onRemove,
  });

  final List<Measurement> items;
  final VoidCallback onAddTap;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Измерения')),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTap,
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Нет данных'))
          : ListView.separated(
        itemCount: items.length,
        itemBuilder: (_, i) => MeasureRow(
          item: items[i],
          onDelete: () => onRemove(items[i].id),
        ),
        separatorBuilder: (_, __) => const Divider(height: 1),
      ),
    );
  }
}
