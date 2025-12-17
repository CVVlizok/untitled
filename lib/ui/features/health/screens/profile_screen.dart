import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../delegates/profile/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadProfile();
    });
  }

  void _editNameDialog(String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Изменить имя'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Имя',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  dialogCtx.read<ProfileCubit>().changeName(newName);
                }
                Navigator.pop(dialogCtx);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _editLoginDialog(String currentLogin) {
    final controller = TextEditingController(text: currentLogin);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Сменить логин'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Новый логин',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newLogin = controller.text.trim();
                if (newLogin.isNotEmpty) {
                  dialogCtx.read<ProfileCubit>().changeLogin(newLogin);
                }
                Navigator.pop(dialogCtx);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _editPasswordDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Сменить пароль'),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Новый пароль',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPass = controller.text.trim();
                if (newPass.isNotEmpty) {
                  ScaffoldMessenger.of(dialogCtx).showSnackBar(
                    const SnackBar(content: Text('Пароль успешно изменён')),
                  );
                }
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
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = state.profile;
            if (profile == null) {
              return const Center(child: Text('Профиль не загружен'));
            }

            return Column(
              children: [
                // Первый ряд кнопок
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushReplacement('/parameters'),
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
                      child: OutlinedButton.icon(
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
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.pushReplacement('/mood'),
                        icon: const Icon(Icons.mood),
                        label: const Text('Настроение'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Практическая работа №13 - Сетевой слой
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => context.push('/health-news'),
                        icon: const Icon(Icons.newspaper),
                        label: const Text('Новости о здоровье'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => context.push('/health-research'),
                        icon: const Icon(Icons.science),
                        label: const Text('Научные статьи'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: 96,
                  height: 96,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/128/10438/10438143.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => _editNameDialog(profile.name),
                  child: const Text('Изменить имя'),
                ),

                const SizedBox(height: 8),

                Text(
                  'Логин: ${profile.login}',
                  style: const TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () => _editLoginDialog(profile.login),
                  child: const Text('Сменить логин'),
                ),

                TextButton(
                  onPressed: () => _editPasswordDialog(),
                  child: const Text('Сменить пароль'),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(Icons.logout),
                    label: const Text('Выйти'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
