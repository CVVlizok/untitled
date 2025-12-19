import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../delegates/measurements/measurements_cubit.dart';
import 'package:untitled/core/models/measurement.dart';
import '../widgets/measure_table.dart';

class MeasureListScreen extends StatefulWidget {
  final String title;

  const MeasureListScreen({super.key, required this.title});

  @override
  State<MeasureListScreen> createState() => _MeasureListScreenState();
}

class _MeasureListScreenState extends State<MeasureListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeasurementsCubit>().loadMeasurementsByType(widget.title);
    });
  }

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

    if (result != null && context.mounted) {
      context.read<MeasurementsCubit>().addMeasurement(result);

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('Новое измерение добавлено')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageFor(widget.title);

    return Scaffold(
      appBar: AppBar(
        title: Text('Измерения: ${widget.title}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
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
                          '/parameters/measure/$seg',
                        );
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
            child: BlocConsumer<MeasurementsCubit, MeasurementsState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: ${state.error}')),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = state.measurements
                    .where((m) => m.type == widget.title)
                    .toList(growable: false);

                if (items.isEmpty) {
                  return const Center(
                    child: Text('Нет данных для выбранного параметра'),
                  );
                }

                return MeasureTable(
                  items: items,
                  onRemove: (id) {
                    context.read<MeasurementsCubit>().removeMeasurement(id);
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
