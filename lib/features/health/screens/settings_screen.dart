import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dark = false;
  String _lang = 'ru';

  static const _bannerUrl =
      'https://cdn-icons-png.flaticon.com/128/9041/9041000.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
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
                    onPressed: () => context.pushReplacement('/parameters'),
                    icon: const Icon(Icons.monitor_heart),
                    label: const Text('Параметры'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushReplacement('/notes'),
                    icon: const Icon(Icons.note),
                    label: const Text('Заметки'),
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
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  title: const Text('Тёмная тема'),
                  value: _dark,
                  onChanged: (v) => setState(() => _dark = v),
                  subtitle:
                  const Text('Переключение темы (локальная настройка)'),
                  secondary: const Icon(Icons.dark_mode),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Язык'),
                  subtitle: Text(_lang == 'ru' ? 'Русский' : 'English'),
                  trailing: DropdownButton<String>(
                    value: _lang,
                    onChanged: (v) => setState(() => _lang = v ?? 'ru'),
                    items: const [
                      DropdownMenuItem(
                        value: 'ru',
                        child: Text('Русский'),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('О приложении'),
                  subtitle: Text(
                    'Health — учебное приложение для работы с параметрами '
                        'здоровья, заметками и профилем пользователя.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}