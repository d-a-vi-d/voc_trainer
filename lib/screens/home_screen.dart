import 'package:flutter/material.dart';
import 'add_word_screen.dart';
import 'learn_screen.dart';
import 'overview_screen.dart';


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