import 'package:flutter/material.dart';

class PressureScreen extends StatefulWidget {
  const PressureScreen({super.key});

  @override
  State<PressureScreen> createState() => _PressureScreenState();
}

class _PressureScreenState extends State<PressureScreen> {
  final List<String> _pressureList = [];
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

  void _showInputDialog() {
    _systolicController.clear();
    _diastolicController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Введите давление"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _systolicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Систолическое (верхнее)",
                ),
              ),
              TextField(
                controller: _diastolicController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Диастолическое (нижнее)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                final top = _systolicController.text.trim();
                final bottom = _diastolicController.text.trim();
                if (top.isNotEmpty && bottom.isNotEmpty) {
                  setState(() {
                    _pressureList.add("$top / $bottom мм рт. ст.");
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() => _pressureList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Давление")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Измерения давления:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _pressureList.isEmpty
                  ? const Center(
                child: Text(
                  "Пока нет измерений",
                  style: TextStyle(color: Colors.black54),
                ),
              )
                  : ListView(
                children: _pressureList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final pressure = entry.value;
                  return ListTile(
                    title: Text(pressure),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(index),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showInputDialog,
              child: const Text("Добавить измерение"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Назад"),
            ),
          ],
        ),
      ),
    );
  }
}
