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
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      AddWordScreen(),
      LearnScreen(),
      OverviewScreen(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Voc Trainer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6FF), Color(0xFFF9F9F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(), // für sanftes Ende
          children: screens,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: const Color(0xFF2980B9),
            unselectedItemColor: Colors.grey[400],
            showUnselectedLabels: true,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500), // länger für smooth
                  curve: Curves.easeInOutCubic, // sanftere Kurve
                );
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, size: 28),
                label: 'Wörter',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school, size: 28),
                label: 'Lernen',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, size: 28),
                label: 'Übersicht',
              ),
            ],
          ),
        ),
      ),
    );
  }
}