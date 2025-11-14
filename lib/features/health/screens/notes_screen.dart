// lib/features/health/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/notes/notes_cubit.dart';
import '../models/note_entry.dart';
import '../widgets/note_tile.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  static const _bannerUrl =
      'https://cdn-icons-png.flaticon.com/128/6711/6711178.png';

  void _addNoteDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Новая заметка'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration:
            const InputDecoration(hintText: 'Напишите заметку…'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  Navigator.pop(dialogCtx);
                  return;
                }

                final now = DateTime.now();
                String two(int v) => v < 10 ? '0$v' : '$v';
                final date =
                    '${now.year}-${two(now.month)}-${two(now.day)}';

                final note = NoteEntry(
                  id: now.microsecondsSinceEpoch.toString(),
                  text: text,
                  date: date,
                );

                // Добавляем заметку через Cubit (состояние = List<NoteEntry>)
                dialogCtx.read<NotesCubit>().addNote(note);

                Navigator.pop(dialogCtx);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Заметки')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNoteDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // горизонтальная навигация
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

          // картинка
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

          // список заметок: состояние = List<NoteEntry>
          Expanded(
            child: BlocBuilder<NotesCubit, List<NoteEntry>>(
              builder: (context, notes) {
                if (notes.isEmpty) {
                  return const Center(
                    child: Text('Заметок пока нет'),
                  );
                }

                return ListView.separated(
                  itemCount: notes.length,
                  itemBuilder: (context, index) =>
                      NoteTile(note: notes[index]),
                  separatorBuilder: (_, __) => const Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
