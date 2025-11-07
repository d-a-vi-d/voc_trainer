import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/language_bar.dart';
import 'voc_screen.dart';
import 'learn_mode_screen.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedLangIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _addLanguageDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache hinzufügen'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Sprache'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              final newLang = controller.text.trim();
              if (newLang.isNotEmpty) {
                WordService.addLanguage(newLang);
                setState(() {});
              }
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  void _deleteLanguage(String lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache löschen'),
        content: Text(
            'Möchtest du "$lang" und alle zugehörigen Wörter wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              WordService.removeLanguage(lang);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagetile(int index) => Container(   
    margin: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: index == selectedLangIndex ? Colors.green : Colors.white,
      borderRadius: BorderRadius.circular(15), 
      border: Border.all(color: Colors.black, width: 3),
    ),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(10),
    transform: index == selectedLangIndex ? Matrix4.rotationZ(0.0) : index < selectedLangIndex ? Matrix4.rotationZ(-0.05) : Matrix4.rotationZ(0.05),
    child: Text(
        WordService.languages[index],
        style: TextStyle(
          fontSize: 20,
          fontWeight: index == selectedLangIndex ? FontWeight.bold : FontWeight.normal
          )
      ),
  );

  @override
  Widget build(BuildContext context) {
    final currentLang = WordService.languages[selectedLangIndex];

    const Color mainGreen = Color(0xFF4CB78A);
    const Color accentGreen = Color(0xFF7DD8A7);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentLang),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LearnModeScreen(language: currentLang),
                ),
              );
            },
            child: const Text('Lernen'),
          )
        ],
      ),
      body: VocScreen(language: currentLang),
      bottomNavigationBar: SizedBox(
        height: 80,


        child: ReorderableListView(
          proxyDecorator: (Widget child, int index, Animation<double> animation) => _buildLanguagetile(index),
          scrollDirection: Axis.horizontal,          
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) newIndex -= 1;
              final previouslySelected = WordService.languages[selectedLangIndex];
              final String item = WordService.languages.removeAt(oldIndex);
              WordService.languages.insert(newIndex, item);

              selectedLangIndex = WordService.languages.indexOf(previouslySelected);
              if (selectedLangIndex == -1) selectedLangIndex = 0;

              WordService.saveLanguages();
            });
          },
          children: <Widget>[
            for (int index = 0; index < WordService.languages.length; index += 1)
              GestureDetector(
                onTap:() {                  
                  setState(() {
                    selectedLangIndex = index;
                  });
                },                
                key: Key('$index'),
                child: _buildLanguagetile(index)
              ),
          ],
        )
        // child: LanguageBar(
        //   langList: currentWordService.languages,
        //   selectedLangIndex: selectedLangIndex,
        //   draggingIndex: draggingIndex,
        //   dropPreviewIndex: dropPreviewIndex,
        //   isDraggingMode: isDraggingMode,
        //   onSelect: (index) => setState(() => selectedLangIndex = index),
        //   onAddLanguage: _addLanguageDialog,
        //   onDrop: (index) {
        //     setState(() {
        //       if (draggingIndex != null) {
        //         if (index == null) return; // index ist null → nichts tun
        //         if (index == -1) {
        //           // Losgelassen auf Mülleimer
        //           _deleteLanguage(currentWordService.languages[draggingIndex!]);
        //         } else if (index >= 0 && draggingIndex != index) {
        //           final moved = currentWordService.languages.removeAt(draggingIndex!);
        //           currentWordService.languages.insert(index, moved);
        //           selectedLangIndex = currentWordService.languages.indexOf(moved);
        //         }
        //       }
        //       draggingIndex = null;
        //       dropPreviewIndex = null;
        //       isDraggingMode = false;
        //     });

        //   },
        //   onDelete: (index) => _deleteLanguage(currentWordService.languages[index]),
        //   onDragStart: (index) {
        //     setState(() {
        //       draggingIndex = index;
        //       dropPreviewIndex = index;
        //       isDraggingMode = true;
        //     });
        //   },
        //   onDragUpdate: (targetIndex) {
        //     setState(() {
        //       dropPreviewIndex = targetIndex;
        //     });
        //   },
        //   onDragEnd: () {
        //     setState(() {
        //       draggingIndex = null;
        //       dropPreviewIndex = null;
        //       isDraggingMode = false;
        //     });
        //   },
        //   mainGreen: mainGreen,
        //   accentGreen: accentGreen,
        // ),
      ),


    );
  }
}
