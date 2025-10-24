import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageFor(title);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              height: 80,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                progressIndicatorBuilder: (context, url, progress) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: MeasureTable(
              items: items,
              onRemove: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
