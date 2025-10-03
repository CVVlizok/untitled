import 'package:flutter/material.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int _weight = 70; // начальное значение веса

  void _increaseWeight() {
    setState(() {
      _weight += 5;
    });
  }

  void _decreaseWeight() {
    setState(() {
      _weight -= 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Вес")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ваш вес:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "$_weight кг",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decreaseWeight,
                  child: const Text("- Уменьшить"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _increaseWeight,
                  child: const Text("+ Увеличить"),
                ),
              ],
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
