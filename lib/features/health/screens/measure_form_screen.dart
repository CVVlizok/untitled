import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/measurement.dart';

class MeasureFormScreen extends StatefulWidget {
  const MeasureFormScreen({
    super.key,
    required this.selectedType, // 'Пульс' | 'Давление' | 'Температура' | 'Вес'
    required this.onCancel,
    required this.onSave,
  });

  final String selectedType;
  final VoidCallback onCancel;
  final void Function(Measurement) onSave;

  @override
  State<MeasureFormScreen> createState() => _MeasureFormScreenState();
}

class _MeasureFormScreenState extends State<MeasureFormScreen> {
  final _valueCtrl = TextEditingController();

  // для давления
  final _sysCtrl = TextEditingController();
  final _diaCtrl = TextEditingController();

  static const Map<String, String> _units = {
    'Пульс': 'уд/мин',
    'Давление': 'мм рт. ст.',
    'Температура': '°C',
    'Вес': 'кг',
  };

  @override
  void dispose() {
    _valueCtrl.dispose();
    _sysCtrl.dispose();
    _diaCtrl.dispose();
    super.dispose();
  }

  void _save() {
    String value;
    if (widget.selectedType == 'Давление') {
      final top = _sysCtrl.text.trim();
      final bottom = _diaCtrl.text.trim();
      if (top.isEmpty || bottom.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заполните оба значения давления')),
        );
        return;
      }
      value = '$top/$bottom';
    } else {
      value = _valueCtrl.text.trim();
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите значение')),
        );
        return;
      }
    }

    final unit = _units[widget.selectedType] ?? '';
    widget.onSave(
      Measurement(
        id: const Uuid().v4(),
        type: widget.selectedType,
        value: value,
        unit: unit,
        date: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.selectedType;

    return Scaffold(
      appBar: AppBar(title: Text('Новое измерение: $type')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (type == 'Давление') ...[
              TextField(
                controller: _sysCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Систолическое (верхнее)',
                  hintText: 'Например: 120',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _diaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Диастолическое (нижнее)',
                  hintText: 'Например: 80',
                ),
              ),
            ] else ...[
              TextField(
                controller: _valueCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Значение',
                  hintText: type == 'Температура' ? 'Например: 36.6' : null,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Отмена'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Сохранить'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Единица измерения: ${_units[type] ?? ''}',
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
