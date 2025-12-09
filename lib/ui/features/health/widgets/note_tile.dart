import 'package:flutter/material.dart';
import 'package:untitled/core/models/note_entry.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note});

  final NoteEntry note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.text),
      subtitle: Text(note.date),
    );
  }
}