import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../container/service_locator.dart';
import '../container/notes_store.dart';
import '../widgets/note_tile.dart';
import '../models/note_entry.dart';

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
            decoration:
            const InputDecoration(hintText: 'Напишите заметку…'),
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
                final date =
                    '${now.year}-${two(now.month)}-${two(now.day)}';

                if (!locator.isRegistered<NotesStore>()) {
                  print('Ошибка: NotesStore не зарегистрирован в GetIt!');
                  Navigator.pop(context);
                  return;
                }

                final store = locator.get<NotesStore>();
                store.add(
                  NoteEntry(
                    id: now.microsecondsSinceEpoch.toString(),
                    text: text,
                    date: date,
                  ),
                );

                // <<< главное изменение: перерисовать экран >>>
                setState(() {});

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
    if (!locator.isRegistered<NotesStore>()) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Ошибка: хранилище заметок не зарегистрировано',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    final store = locator.get<NotesStore>();
    final notes = store.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
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
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.pushReplacement('/parameters'),
                    icon: const Icon(Icons.monitor_heart),
                    label: const Text('Параметры'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.pushReplacement('/settings'),
                    icon: const Icon(Icons.settings),
                    label: const Text('Настройки'),
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
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: notes.length,
              itemBuilder: (context, index) =>
                  NoteTile(note: notes[index]),
              separatorBuilder: (_, __) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}