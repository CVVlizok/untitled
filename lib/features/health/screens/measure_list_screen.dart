import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../container/service_locator.dart';
import '../container/measurements_store.dart';
import '../models/measurement.dart';
import '../widgets/measure_table.dart';

class MeasureListScreen extends StatefulWidget {
  final String title; // тип параметра (например, "Пульс")

  const MeasureListScreen({super.key, required this.title});

  @override
  State<MeasureListScreen> createState() => _MeasureListScreenState();
}

class _MeasureListScreenState extends State<MeasureListScreen> {
  static const _types = ['Пульс', 'Давление', 'Температура', 'Вес'];

  String _imageFor(String t) {
    const urls = {
      'Пульс':
      'https://cdn-icons-png.flaticon.com/512/4473/4473602.png',
      'Давление':
      'https://cdn-icons-png.flaticon.com/512/9785/9785878.png',
      'Температура':
      'https://cdn-icons-png.flaticon.com/512/3534/3534501.png',
      'Вес':
      'https://cdn-icons-png.flaticon.com/128/5998/5998704.png',
    };
    const fallback =
        'https://cdn-icons-png.flaticon.com/512/4486/4486599.png';
    return urls[t] ?? fallback;
  }

  Future<void> _addMeasurement(BuildContext context) async {
    final seg = Uri.encodeComponent(widget.title);
    final result =
    await context.push<Measurement>('/parameters/measure/$seg/new');

    if (result != null) {
      if (!locator.isRegistered<MeasurementsStore>()) {
        print('Ошибка: MeasurementsStore не зарегистрирован в GetIt!');
        return;
      }
      final store = locator.get<MeasurementsStore>();
      store.add(result, onChange: () {
        setState(() {});
      });

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('Новое измерение добавлено')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!locator.isRegistered<MeasurementsStore>()) {
      print('Ошибка: MeasurementsStore не зарегистрирован в GetIt!');
      return const Scaffold(
        body: Center(
          child: Text(
            'Ошибка: данные недоступны',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    final store = locator.get<MeasurementsStore>();
    final items = store.byType(widget.title);
    final imageUrl = _imageFor(widget.title);

    return Scaffold(
      appBar: AppBar(
        title: Text('Измерения: ${widget.title}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // назад к списку параметров
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMeasurement(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // картинка
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _types.asMap().entries.map((entry) {
                final index = entry.key;
                final t = entry.value;
                final selected = t == widget.title;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == _types.length - 1 ? 0 : 8,
                    ),
                    child: ElevatedButton(
                      onPressed: selected
                          ? null
                          : () {
                        final seg = Uri.encodeComponent(t);
                        context.pushReplacement(
                            '/parameters/measure/$seg');
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

          Expanded(
            child: MeasureTable(
              items: items,
              onRemove: (id) {
                store.removeWithUndo(
                  context,
                  id,
                  onChange: () {
                    setState(() {});
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