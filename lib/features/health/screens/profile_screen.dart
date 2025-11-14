// lib/features/health/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Имя пользователя';
  String _login = 'user@example.com';

  void _editNameDialog() {
    final controller = TextEditingController(text: _name);

    showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  setState(() => _name = newName);
                }
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            )
          ],
        );
      },
    );
  }

  void _editLoginDialog() {
    final controller = TextEditingController(text: _login);

    showDialog(
      context: context,
      builder: (_) {
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newLogin = controller.text.trim();
                if (newLogin.isNotEmpty) {
                  setState(() => _login = newLogin);
                }
                Navigator.pop(context);
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
      builder: (_) {
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPass = controller.text.trim();
                if (newPass.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пароль успешно изменён')),
                  );
                }
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
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Имя ---
            Text(
              _name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: _editNameDialog,
              child: const Text('Изменить имя'),
            ),

            const SizedBox(height: 8),

            // --- Логин ---
            Text(
              'Логин: $_login',
              style: const TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: _editLoginDialog,
              child: const Text('Сменить логин'),
            ),

            TextButton(
              onPressed: _editPasswordDialog,
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
        ),
      ),
    );
  }
}
