// lib/features/health/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../container/app_state.dart';      // ← добавили доступ к InheritedWidget
import '../models/note_entry.dart';
import '../widgets/note_tile.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
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
                String two(int v) => v < 10 ? '0$v' : '$v';
                final date = '${now.year}-${two(now.month)}-${two(now.day)}';

                // ← пишем в глобальный стор через InheritedWidget
                final app = AppStateScope.of(context);
                app.addNote(
                  NoteEntry(
                    id: now.microsecondsSinceEpoch.toString(),
                    text: text,
                    date: date,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final app = AppStateScope.of(context);
    final notes = app.allNotes();

    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Горизонтальная навигация между разделами (без истории)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pushReplacement('/profile'),
                    icon: const Icon(Icons.person),
                    label: const Text('Профиль'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushReplacement('/parameters'),
                    icon: const Icon(Icons.monitor_heart),
                    label: const Text('Параметры'),
                  ),
                ),
              ],
            ),
          ),

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
              itemCount: notes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) => NoteTile(note: notes[index]),
            ),
          ),
        ],
      ),
    );
  }
}
