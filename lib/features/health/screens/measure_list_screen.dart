import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../container/app_state.dart';           // ← единый импорт InheritedWidget
import '../models/measurement.dart';
import '../widgets/measure_table.dart';

class MeasureListScreen extends StatelessWidget {
  const MeasureListScreen({
    super.key,
    required this.title, // тип параметра (например, "Пульс")
  });

  final String title;

  String _imageFor(String t) {
    const urls = {
      'Пульс'      : 'https://cdn-icons-png.flaticon.com/512/4473/4473602.png',
      'Давление'   : 'https://cdn-icons-png.flaticon.com/512/9785/9785878.png',
      'Температура': 'https://cdn-icons-png.flaticon.com/512/3534/3534501.png',
      'Вес'        : 'https://cdn-icons-png.flaticon.com/128/5998/5998704.png',
    };
    const fallback = 'https://cdn-icons-png.flaticon.com/512/4486/4486599.png';
    return urls[t] ?? fallback;
  }

  Future<void> _addMeasurement(BuildContext context) async {
    final seg = Uri.encodeComponent(title);
    final result = await context.push<Measurement>('/parameters/measure/$seg/new');
    if (result != null) {
      final app = AppStateScope.of(context);
      app.addMeasurement(result);

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('Новое измерение добавлено')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppStateScope.of(context);
    final items = app.measurementsByType(title);
    final imageUrl = _imageFor(title);

    const types = ['Пульс', 'Давление', 'Температура', 'Вес'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Измерения: $title'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'К параметрам',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMeasurement(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              height: 80,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                progressIndicatorBuilder: (_, __, ___) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                const Center(child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
          ),

          // Горизонтальное переключение между типами БЕЗ истории (pushReplacement)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: types.asMap().entries.map((entry) {
                final i = entry.key;
                final t = entry.value;
                final selected = t == title;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == types.length - 1 ? 0 : 8),
                    child: ElevatedButton(
                      onPressed: selected
                          ? null
                          : () {
                        final seg = Uri.encodeComponent(t);
                        context.pushReplacement('/parameters/measure/$seg');
                      },
                      child: Text(t),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // Таблица значений из глобального стора
          Expanded(
            child: MeasureTable(
              items: items,
              onRemove: (id) {
                // Используем встроенное удаление с Undo из AppStateScope
                app.removeMeasurementWithUndo(context, id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
