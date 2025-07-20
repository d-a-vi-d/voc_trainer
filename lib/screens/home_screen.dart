import 'package:flutter/material.dart';
import '../widgets/language_bar.dart';
import '../utils/languages.dart';
import 'voc_screen.dart';
import '../services/word_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> languages; // Liste der Sprachen
  late String _currentLanguage;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    languages = getLanguages(); // hol dir die Liste der Sprachen
    _currentLanguage = languages.isNotEmpty ? languages.first : ''; // Standardmäßig die erste Sprache auswählen
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showAddLanguageDialog() {  
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Neue Sprache hinzufügen'),
          content: TextField(   
            controller: controller,         
            decoration: const InputDecoration(hintText: 'Sprache'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newLang = controller.text.trim();
                if (newLang.isNotEmpty && !languages.contains(newLang)) {
                  await WordService.addLanguage(newLang);
                  setState(() {
                    languages = getLanguages(); // Aktualisiere die Liste der Sprachen
                    _currentLanguage = newLang;
                  });
                }
                controller.clear();
                if (!mounted) return;  // Wenn Widget nicht mehr aktiv, nichts machen
                Navigator.of(context).pop();
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VocScreen(language: _currentLanguage),
      bottomNavigationBar: LanguageBar(
        languages: languages,
        selectedLanguage: _currentLanguage,
        onLanguageSelected: (lang) {
          setState(() {
            _currentLanguage = lang;
          });
        },
        onAddLanguage: _showAddLanguageDialog,
      ), 
    );
  }  
}
