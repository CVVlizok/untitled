import 'package:flutter/material.dart';

class _TempEntry {
  _TempEntry(this.value, this.status, this.color);
  final double value;
  final String status;
  final Color color;
}

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_TempEntry> _items = [];

  void _showInputDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Введите температуру"),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Например: 36.6"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
          ElevatedButton(
            onPressed: () {
              final raw = _controller.text.trim().replaceAll(',', '.');
              final val = double.tryParse(raw);
              if (val != null) _addTemperature(val);
              Navigator.pop(context);
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  void _addTemperature(double value) {
    String status;
    Color color;
    if (value < 36.0) {
      status = "Понижена";
      color = Colors.blue;
    } else if (value > 37.0) {
      status = "Повышена";
      color = Colors.red;
    } else {
      status = "Норма";
      color = Colors.green;
    }
    setState(() => _items.add(_TempEntry(value, status, color)));
  }

  void _removeItem(int index) => setState(() => _items.removeAt(index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Температура")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Температура тела", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _showInputDialog, child: const Text("Ввести значение")),
            const SizedBox(height: 12),

            // если пусто — показываем сообщение
            if (_items.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("Пока нет измерений", style: TextStyle(color: Colors.black54)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      key: ValueKey('${item.value}-$index'),
                      leading: Icon(Icons.thermostat, color: item.color),
                      title: Text(
                        "${item.value.toStringAsFixed(1)} °C",
                        style: TextStyle(color: item.color, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.status),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeItem(index),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("Назад")),
          ],
        ),
      ),
    );
  }
}
