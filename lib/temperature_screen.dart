import 'package:flutter/material.dart';

class _TempEntry {
  _TempEntry(this.value, this.status, this.color)
      : id = DateTime.now().microsecondsSinceEpoch.toString(); // уникальный ключ

  final String id;      // уникальный идентификатор
  final double value;   // значение температуры
  final String status;  // статус (норма/повышена/понижена)
  final Color color;    // цвет для отображения
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
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

  void _removeItem(String id) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final removed = _items[index];
    setState(() => _items.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Удалено: ${removed.value.toStringAsFixed(1)} °C"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Температура")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Температура тела",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showInputDialog,
              child: const Text("Ввести значение"),
            ),
            const SizedBox(height: 12),

            if (_items.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "Пока нет измерений",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: _items
                      .map(
                        (item) => GestureDetector(
                      key: ValueKey(item.id), //ключ для каждого элемента
                      onTap: () => _removeItem(item.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        child: ListTile(
                          leading:
                          Icon(Icons.thermostat, color: item.color),
                          title: Text(
                            "${item.value.toStringAsFixed(1)} °C",
                            style: TextStyle(
                              color: item.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(item.status),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () => _removeItem(item.id),
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),

            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Назад"),
            ),
          ],
        ),
      ),
    );
  }
}
