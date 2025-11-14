// lib/features/health/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _editNameDialog(BuildContext context, String currentName) {
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

  void _editLoginDialog(BuildContext context, String currentLogin) {
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

  void _editPasswordDialog(BuildContext context) {
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
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                // --- кнопки навигации ---
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
                  ],
                ),

                const SizedBox(height: 24),

                // --- Аватар ---
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

                // --- Имя ---
                Text(
                  state.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => _editNameDialog(context, state.name),
                  child: const Text('Изменить имя'),
                ),

                const SizedBox(height: 8),

                // --- Логин ---
                Text(
                  'Логин: ${state.login}',
                  style: const TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () => _editLoginDialog(context, state.login),
                  child: const Text('Сменить логин'),
                ),

                TextButton(
                  onPressed: () => _editPasswordDialog(context),
                  child: const Text('Сменить пароль'),
                ),

                const Spacer(),

                // --- кнопка выхода ---
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
