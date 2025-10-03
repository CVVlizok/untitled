import 'package:flutter/material.dart';

class PressureScreen extends StatefulWidget {
  const PressureScreen({super.key});

  @override
  State<PressureScreen> createState() => _PressureScreenState();
}

class _PressureScreenState extends State<PressureScreen> {
  String _systolic = "";
  String _diastolic = "";

  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

  void _showInputDialog() {
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
                setState(() {
                  _systolic = _systolicController.text;
                  _diastolic = _diastolicController.text;
                });
                Navigator.pop(context);
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
    String pressureText =
    (_systolic.isNotEmpty && _diastolic.isNotEmpty)
        ? "$_systolic/$_diastolic мм рт. ст."
        : "—";

    return Scaffold(
      appBar: AppBar(title: const Text("Давление")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ваше давление:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              pressureText,
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
