// lib/features/health/screens/measure_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../container/service_locator.dart';
import '../models/measurement.dart';
import '../container/measurements_store.dart';

class MeasureListScreen extends StatelessWidget {
  final String title;

  const MeasureListScreen({super.key, required this.title});

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

    final measurementsStore = locator.get<MeasurementsStore>();
    final items = measurementsStore.byType(title);
    const imageUrl = 'https://cdn-icons-png.flaticon.com/512/4473/4473602.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Измерения: $title'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newMeasurement = Measurement(
            id: 'newId',
            type: title,
            value: '80',
            unit: 'уд/мин',
            date: DateTime.now(),
          );
          measurementsStore.add(newMeasurement);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 80,
              child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  '${items[index].type}: ${items[index].value} ${items[index].unit}',
                ),
              ),
              separatorBuilder: (_, __) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
