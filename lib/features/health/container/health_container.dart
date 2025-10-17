import 'package:flutter/material.dart';

import '../models/measurement.dart';
import '../screens/parameter_picker_screen.dart';
import '../screens/measure_list_screen.dart';
import '../screens/measure_form_screen.dart';

enum HealthScreen { params, list, form }

class HealthContainer extends StatefulWidget {
  const HealthContainer({super.key});
  @override
  State<HealthContainer> createState() => _HealthContainerState();
}

class _HealthContainerState extends State<HealthContainer> {
  HealthScreen _screen = HealthScreen.params;

  final List<Measurement> _items = [];
  String? _selectedType;

  Measurement? _lastRemoved;
  int _lastRemovedIndex = -1;

  void _toParams() => setState(() {
    _screen = HealthScreen.params;
    _selectedType = null;
  });
  void _toList(String type) => setState(() {
    _selectedType = type;
    _screen = HealthScreen.list;
  });
  void _toForm() => setState(() => _screen = HealthScreen.form);

  // данные
  void _add(Measurement m) {
    setState(() {
      _items.add(m);
      _screen = HealthScreen.list;
    });
  }

  void _remove(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx < 0) return;
    setState(() {
      _lastRemoved = _items.removeAt(idx);
      _lastRemovedIndex = idx;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Измерение удалено'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            if (_lastRemoved != null && _lastRemovedIndex >= 0) {
              setState(() {
                _items.insert(_lastRemovedIndex, _lastRemoved!);
                _lastRemoved = null;
                _lastRemovedIndex = -1;
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case HealthScreen.params:
        return ParameterPickerScreen(onPick: _toList);

      case HealthScreen.list:
        final type = _selectedType ?? '—';
        final filtered = _items.where((e) => e.type == type).toList();
        return MeasureListScreen(
          title: type,
          items: filtered,
          onAddTap: _toForm,
          onRemove: _remove,
          onBackToParams: _toParams,
        );

      case HealthScreen.form:
        return MeasureFormScreen(
          selectedType: _selectedType!,
          onCancel: () => _screen = HealthScreen.list,
          onSave: _add,
        );
    }
  }
}
