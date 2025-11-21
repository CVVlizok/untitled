import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../bloc/water/water_cubit.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  static const _bannerUrl =
      'https://cdn-icons-png.flaticon.com/128/7126/7126715.png';

  String _formatDate(DateTime d) {
    String two(int v) => v < 10 ? '0$v' : '$v';
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Водный баланс')),
      body: BlocBuilder<WaterCubit, WaterState>(
        builder: (context, state) {
          final target = state.targetCups;
          final drunk = state.drunkCups;
          final history = state.history;
          final progress =
          target == 0 ? 0.0 : (drunk / target).clamp(0.0, 1.0);
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
                        onPressed: () => context.pushReplacement('/mood'),
                        icon: const Icon(Icons.mood),
                        label: const Text('Настроение'),
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
                child: Column(
                  children: [
                    Text(
                      'Выпито $drunk из $target стаканов',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(target, (index) {
                    final filled = index < drunk;
                    return GestureDetector(
                      onTap: () =>
                          context.read<WaterCubit>().toggleCup(index),
                      child: Icon(
                        Icons.local_drink,
                        size: 32,
                        color: filled ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<WaterCubit>().saveToday();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('День сохранён в историю'),
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
                child: history.isEmpty
                    ? const Center(
                  child: Text('История ещё не сохранена'),
                )
                    : ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = history[index];
                    return ListTile(
                      leading: const Icon(Icons.water_drop),
                      title: Text(_formatDate(log.date)),
                      subtitle: Text(
                        'Выпито ${log.drunkCups} из ${log.targetCups} стаканов',
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
}
