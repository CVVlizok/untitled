// lib/features/health/screens/measure_form_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';          // <-- добавили go_router
import 'package:uuid/uuid.dart';
import '../models/measurement.dart';

class MeasureFormScreen extends StatefulWidget {
  const MeasureFormScreen({super.key, required this.selectedType});

  final String selectedType;

  @override
  State<MeasureFormScreen> createState() => _MeasureFormScreenState();
}

class _MeasureFormScreenState extends State<MeasureFormScreen> {
  final _valueCtrl = TextEditingController();
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
    final m = Measurement(
      id: const Uuid().v4(),
      type: widget.selectedType,
      value: value,
      unit: unit,
      date: DateTime.now(),
    );

    // ВЕРТИКАЛЬ: вернуть результат на предыдущий экран через go_router
    context.pop<Measurement>(m);
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.selectedType;

    return Scaffold(
      appBar: AppBar(
        title: Text('Новое измерение: $type'),
      ),
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
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClass {
  final String arg1;
  final String arg2;
  final String arg3;
  final String arg4;
  final String arg5;
  final String arg6;
  final String arg7;
  final String arg8;
  final String arg9;
  final String arg10;

  const MyClass({
    required this.arg1,
    required this.arg2,
    required this.arg3,
    required this.arg4,
    required this.arg5,
    required this.arg6,
    required this.arg7,
    required this.arg8,
    required this.arg9,
    required this.arg10,
  });
}
void main(List<String> args) {
  const obj = MyClass(
    arg1: 'arg',
    arg2: 'arg2',
    arg3: 'arg3',
    arg4: 'arg4',
    arg5: 'arg5',
    arg6: 'arg6',
    arg7: 'arg7',
    arg8: 'arg8',
    arg9: 'arg9',
    arg10: 'arg10',
  );
}

