import 'package:flutter/material.dart';
import 'stful.dart';

void main() {
  runApp(const MyApp());
}

const String kFullName = '\nАгафонова Елизавета Николаевна';
const String kGroup    = '\nГруппа: ИКБО-11-22';
const String kStudent  = '\nСтуденческий: 22И1560';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Практическая работа №3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Мониторинг параметров здоровья'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Нажми'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kFullName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.amber,
                      ),
                    ),
                    Text(
                      kGroup,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      kStudent,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    const Stful(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}