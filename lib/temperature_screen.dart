import 'package:flutter/material.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  String _temperature = "";
  final TextEditingController _controller = TextEditingController();

  void _showInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Введите температуру"),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Например: 36.6",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _temperature = _controller.text;
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
    double? tempValue = double.tryParse(_temperature);
    Color textColor = Colors.black;
    String status = "";

    if (tempValue != null) {
      if (tempValue < 36.0) {
        status = "Понижена";
        textColor = Colors.blue;
      } else if (tempValue > 37.0) {
        status = "Повышена";
        textColor = Colors.red;
      } else {
        status = "Норма";
        textColor = Colors.green;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Температура")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Температура тела:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _temperature.isEmpty ? "—" : "$_temperature °C ($status)",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
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
