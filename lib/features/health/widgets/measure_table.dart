import 'package:flutter/material.dart';
import '../models/measurement.dart';
import 'measure_row.dart';

class MeasureTable extends StatelessWidget {
  const MeasureTable({
    super.key,
    required this.items,
    required this.onRemove,
  });

  final List<Measurement> items;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Нет данных'));
    }

    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final m = items[index];
        return MeasureRow(
          item: m,
          onDelete: () => onRemove(m.id),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }
}