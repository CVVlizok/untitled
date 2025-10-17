import 'package:flutter/material.dart';
import '../models/measurement.dart';
import '../widgets/measure_table.dart';

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
      body: MeasureTable(
        items: items,
        onRemove: onRemove,
      ),
    );
  }
}
