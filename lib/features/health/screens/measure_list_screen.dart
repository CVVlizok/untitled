import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/measurement.dart';
import '../widgets/measure_table.dart';
import '../container/page_nav.dart';

class MeasureListScreen extends StatefulWidget {
  const MeasureListScreen({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<Measurement> items;

  @override
  State<MeasureListScreen> createState() => _MeasureListScreenState();
}

class _MeasureListScreenState extends State<MeasureListScreen> {
  late List<Measurement> _items;

  static const _types = ['Пульс', 'Давление', 'Температура', 'Вес'];

  @override
  void initState() {
    super.initState();
    // стартуем с того, что пришло из роутера
    _items = List<Measurement>.from(widget.items);
  }

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

  Future<void> _addMeasurement() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.measureNew,
      arguments: widget.title,
    ) as Measurement?;

    if (result != null) {
      setState(() {
        _items = List.of(_items)..insert(0, result);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
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
          onPressed: () => Navigator.pop(context), // вертикаль назад
          tooltip: 'К параметрам',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeasurement, // вертикаль вперёд (форма)
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

          // ГОРИЗОНТАЛЬ: переключение между типами без истории
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _types.asMap().entries.map((entry) {
                final i = entry.key;
                final t = entry.value;
                final selected = t == widget.title;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i == _types.length - 1 ? 0 : 8),
                    child: ElevatedButton(
                      onPressed: selected
                          ? null
                          : () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.measureList,
                          arguments: t,
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
            child: MeasureTable(
              items: _items,
              onRemove: (id) {
                setState(() {
                  _items = _items.where((m) => m.id != id).toList();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Измерение удалено')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}