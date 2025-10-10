import 'package:flutter/material.dart';

class PulseScreen extends StatefulWidget {
  const PulseScreen({super.key});

  @override
  State<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends State<PulseScreen> {
  final List<int> _pulseList = [72, 80, 65];
  final TextEditingController _controller = TextEditingController();

  void _showInputDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Введите значение пульса"),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Например: 75",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(_controller.text);
                if (value != null) {
                  setState(() => _pulseList.add(value));
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
    setState(() => _pulseList.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Пульс")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Измерения пульса:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < _pulseList.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade50,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text("${_pulseList[i]} уд/мин"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeItem(i),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showInputDialog,
              child: const Text("Добавить значение"),
            ),
            const SizedBox(height: 10),
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
