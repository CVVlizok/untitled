import 'package:flutter/material.dart';
import '../models/measurement.dart';
import '../widgets/measure_table.dart';

class MeasureListScreen extends StatelessWidget {
  const MeasureListScreen({
    super.key,
    required this.title,
    required this.items,
    required this.onAddTap,
    required this.onRemove,
    required this.onBackToParams,
  });

  final String title;
  final List<Measurement> items;
  final VoidCallback onAddTap;
  final void Function(String id) onRemove;
  final VoidCallback onBackToParams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Измерения: $title'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackToParams,
          tooltip: 'К параметрам',
        ),
      ),
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
