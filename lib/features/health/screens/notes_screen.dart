// lib/features/health/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/note_entry.dart';
import '../widgets/note_tile.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _notes = <NoteEntry>[];
  final _controller = TextEditingController();

  static const _bannerUrl =
      'https://cdn-icons-png.flaticon.com/128/6711/6711178.png';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addNoteDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новая заметка'),
          content: TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Напишите заметку…',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isEmpty) {
                  Navigator.pop(context);
                  return;
                }
                final now = DateTime.now();
                final date = '${now.year}-${_two(now.month)}-${_two(now.day)}';
                setState(() {
                  _notes.insert(
                    0,
                    NoteEntry(
                      id: now.microsecondsSinceEpoch.toString(),
                      text: text,
                      date: date,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  static String _two(int v) => v < 10 ? '0$v' : '$v';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 120,
              child: CachedNetworkImage(
                imageUrl: _bannerUrl,
                fit: BoxFit.contain,
                progressIndicatorBuilder: (_, __, ___) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) =>
                const Center(child: Icon(Icons.error, color: Colors.red)),
              ),
            ),
          ),
          const Text(
            'Заметки',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _notes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) => NoteTile(note: _notes[index]),
            ),
          ),
        ],
      ),
    );
  }
}
