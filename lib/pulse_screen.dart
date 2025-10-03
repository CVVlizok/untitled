import 'package:flutter/material.dart';

class PulseScreen extends StatefulWidget {
  const PulseScreen({super.key});

  @override
  State<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends State<PulseScreen> {
  String _pulseText = ""; // здесь хранится введённое значение
  final TextEditingController _controller = TextEditingController();

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Введите значение пульса"),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Например: 72"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // закрыть окно без изменений
              },
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pulseText = _controller.text;
                });
                Navigator.pop(context); // закрыть окно
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Пульс")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ваш пульс:",
              style: TextStyle(fontSize: 35),
            ),
            const SizedBox(height: 10),
            Text(
              _pulseText.isEmpty ? "—" : "$_pulseText уд/мин",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showInputDialog,
              child: const Text("Ввести значение"),
            ),
            const SizedBox(height: 20),
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
