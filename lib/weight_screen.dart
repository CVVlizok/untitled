import 'package:flutter/material.dart';

class _WeightEntry {
  _WeightEntry(this.value, this.unit);
  final double value;
  final String unit; // "кг" или "фунты"
}

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  final List<_WeightEntry> _history = [];

  final TextEditingController _valueController = TextEditingController();
  String _selectedUnit = 'кг'; // значение по умолчанию

  void _showAddDialog() {
    _valueController.clear();
    _selectedUnit = 'кг';
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Добавить вес'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Значение',
                  hintText: 'например: 70.5',
                ),
              ),
              const SizedBox(height: 12),
              // выбор единицы измерения
              Row(
                children: [
                  const Text('Единица:'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      items: const [
                        DropdownMenuItem(value: 'кг', child: Text('кг')),
                        DropdownMenuItem(value: 'фунты', child: Text('фунты')),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedUnit = v);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final raw = _valueController.text.trim().replaceAll(',', '.');
                final val = double.tryParse(raw);
                if (val != null) {
                  setState(() => _history.add(_WeightEntry(val, _selectedUnit)));
                }
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _removeAt(int index) {
    setState(() => _history.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вес')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'История измерений веса',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Список на ListView.separated
            Expanded(
              child: _history.isEmpty
                  ? const Center(
                child: Text(
                  'Пока нет измерений',
                  style: TextStyle(color: Colors.black54),
                ),
              )
                  : ListView.separated(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final e = _history[index];
                  return ListTile(
                    title: Text('${e.value.toStringAsFixed(1)} ${e.unit}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeAt(index),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showAddDialog,
              child: const Text('Добавить измерение'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}
