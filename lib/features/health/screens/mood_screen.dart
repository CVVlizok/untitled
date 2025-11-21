import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/mood/mood_cubit.dart';

class MoodScreen extends StatelessWidget {
  const MoodScreen({super.key});

  static const _bannerUrl =
      'https://cdn-icons-png.flaticon.com/128/12370/12370029.png';

  String _formatDate(DateTime d) {
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  String _moodText(int level) {
    switch (level) {
      case 1:
        return 'Очень плохо';
      case 2:
        return 'Плохо';
      case 3:
        return 'Нормально';
      case 4:
        return 'Хорошо';
      case 5:
        return 'Отлично';
      default:
        return 'Не указано';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настроение')),
      body: BlocBuilder<MoodCubit, MoodState>(
        builder: (context, state) {
          final current = state.currentMood;

          return Column(
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
                      child: OutlinedButton.icon(
                        onPressed: () => context.pushReplacement('/notes'),
                        icon: const Icon(Icons.note),
                        label: const Text('Заметки'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushReplacement('/settings'),
                        icon: const Icon(Icons.settings),
                        label: const Text('Настройки'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushReplacement('/water'),
                        icon: const Icon(Icons.water_drop_outlined),
                        label: const Text('Водный баланс'),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMoodIcon(context, level: 1, current: current),
                    _buildMoodIcon(context, level: 2, current: current),
                    _buildMoodIcon(context, level: 3, current: current),
                    _buildMoodIcon(context, level: 4, current: current),
                    _buildMoodIcon(context, level: 5, current: current),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Flexible(child: Text('Очень плохо', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
                    Flexible(child: Text('Плохо', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
                    Flexible(child: Text('Нормально', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
                    Flexible(child: Text('Хорошо', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
                    Flexible(child: Text('Отлично', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Добавить запись (опционально)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      context.read<MoodCubit>().changeNote(value),
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<MoodCubit>().saveToday();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Запись по настроению сохранена'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Сохранить день в историю'),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1),

              Expanded(
                child: state.history.isEmpty
                    ? const Center(
                  child: Text('История настроения ещё не сохранена'),
                )
                    : ListView.separated(
                  itemCount: state.history.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = state.history[index];
                    return ListTile(
                      leading: const Icon(Icons.emoji_emotions),
                      title: Text(_formatDate(log.date)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Настроение: ${_moodText(log.moodLevel)}'),
                          if (log.note.isNotEmpty)
                            Text(
                              log.note,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoodIcon(
      BuildContext context, {
        required int level,
        required int? current,
      }) {
    IconData icon;
    switch (level) {
      case 1:
        icon = Icons.sentiment_very_dissatisfied;
        break;
      case 2:
        icon = Icons.sentiment_dissatisfied;
        break;
      case 3:
        icon = Icons.sentiment_neutral;
        break;
      case 4:
        icon = Icons.sentiment_satisfied;
        break;
      case 5:
        icon = Icons.sentiment_very_satisfied;
        break;
      default:
        icon = Icons.sentiment_satisfied;
    }

    final selected = current == level;

    return IconButton(
      onPressed: () => context.read<MoodCubit>().selectMood(level),
      icon: Icon(
        icon,
        size: 36,
        color: selected ? Colors.amber : Colors.grey,
      ),
    );
  }
}
