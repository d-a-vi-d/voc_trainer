import 'package:flutter/material.dart';
import 'screens/add_word_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/overview_screen.dart';
import 'package:voc_trainer/services/word_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await WordService.loadWords();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voc Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AddWordScreen(),
    LearnScreen(),
    OverviewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Wörter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Lernen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Übersicht',
          ),
        ],
      ),
    );
  }
}

// languages löschen

// learnmodescreen appbar stern entfernen
// was macht SliverGridDelegateWithFixedCrossAxisCount
// schneller vok eingeben
// übersetzung nicht gleich eingeben
// overview mit persönlichen sprachen
// voc screen bottombar
// alles schöner machen