import 'package:flutter/material.dart';
class Stful extends StatefulWidget {
  const Stful({super.key});

  @override
  State<Stful> createState() => _StfulState();
}

class _StfulState extends State<Stful> {
  String _text = "Это простой Stateful Widget";

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.green,
      ),
    );
  }
}

