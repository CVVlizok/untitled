import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/measurement.dart';

class MeasureFormScreen extends StatefulWidget {
  const MeasureFormScreen({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final void Function(Measurement) onSave;

  @override
  State<MeasureFormScreen> createState() => _MeasureFormScreenState();
}

class _MeasureFormScreenState extends State<MeasureFormScreen> {
  final _typeCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _unitCtrl  = TextEditingController();

  @override
  void dispose() {
    _typeCtrl.dispose();
    _valueCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_typeCtrl.text.trim().isEmpty ||
        _valueCtrl.text.trim().isEmpty ||
        _unitCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    widget.onSave(
      Measurement(
        id: const Uuid().v4(),
        type: _typeCtrl.text.trim(),
        value: _valueCtrl.text.trim(),
        unit: _unitCtrl.text.trim(),
        date: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новое измерение')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _typeCtrl,
              decoration: const InputDecoration(
                labelText: 'Тип (например: Пульс, Давление, Температура, Вес)',
              ),
            ),
            TextField(
              controller: _valueCtrl,
              decoration: const InputDecoration(
                labelText: 'Значение (например: 72 или 120/80)',
              ),
            ),
            TextField(
              controller: _unitCtrl,
              decoration: const InputDecoration(
                labelText: 'Единица (уд/мин, мм рт. ст., °C, кг)',
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
