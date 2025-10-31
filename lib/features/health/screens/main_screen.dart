import 'package:flutter/material.dart';
import '../container/page_nav.dart';
import 'profile_screen.dart';
import 'parameter_picker_screen.dart';
import 'notes_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (index == _index) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(initialIndex: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Тела вкладок (без своих bottom bars)
    final pages = <Widget>[
      const ProfileScreen(),
      ParameterPickerScreen(
        onPick: (type) {
          Navigator.of(context).pushNamed(AppRoutes.measureList, arguments: type);
        },
      ),
      const NotesScreen(),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => _onItemTapped(context, i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Параметры'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Заметки'),
        ],
      ),
    );
  }
}
