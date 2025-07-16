import 'package:flutter/material.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class VocScreen extends StatefulWidget {
  final String language;
  final VoidCallback? onChanged;
  const VocScreen({super.key, required this.language, this.onChanged});

  static Future<void> showAddWordDialog(BuildContext context, String language, {VoidCallback? onWordAdded}) async {
    final wordController = TextEditingController();
    final translationController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Neues Wort für $language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: wordController,
              decoration: const InputDecoration(labelText: 'Wort'),
            ),
            TextField(
              controller: translationController,
              decoration: const InputDecoration(labelText: 'Übersetzung'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              final word = wordController.text.trim();
              final translation = translationController.text.trim();
              if (word.isNotEmpty && translation.isNotEmpty) {
                WordService.words.add(
                  Word(word: word, translation: translation, language: language),
                );
                WordService.saveWords();
                if (onWordAdded != null) onWordAdded();
              }
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  @override
    State<VocScreen> createState() => _VocScreenState();
  }


class _VocScreenState extends State<VocScreen> {
  final Map<Word, bool> editMode = {}; // pro Wort merken
  
  @override
  Widget build(BuildContext context) {
    List<Word> words = WordService.getWordsForLanguage(widget.language);

    return Scaffold(
      body: Column(
        children: [          
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                final isEditing = editMode[word] ?? false;
                final wordController = TextEditingController(text: word.word);
                final translationController =
                    TextEditingController(text: word.translation);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: isEditing
                              ? Column(
                                  children: [
                                    TextField(
                                      controller: wordController,
                                      decoration:
                                          const InputDecoration(hintText: 'Wort'),
                                      onSubmitted: (_) {
                                        word.word = wordController.text;
                                      },
                                    ),
                                    TextField(
                                      controller: translationController,
                                      decoration: const InputDecoration(
                                          hintText: 'Übersetzung'),
                                      onSubmitted: (_) {
                                        word.translation =
                                            translationController.text;
                                      },
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      word.word,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      word.translation,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: isEditing
                                  ? const Icon(Icons.delete, color: Colors.red)
                                  : Icon(
                                      word.learned
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: word.learned ? Colors.green : Colors.grey,
                                    ),
                              onPressed: () {
                                setState(() {
                                  if (isEditing) {
                                    WordService.removeWord(word);
                                  } else {
                                    word.learned = !word.learned;
                                    WordService.saveWords();
                                    if (widget.onChanged != null) widget.onChanged!();
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isEditing ? Icons.check : Icons.edit,
                                color: isEditing ? Colors.green : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isEditing) {
                                    // Eingaben übernehmen
                                    word.word = wordController.text;
                                    word.translation = translationController.text;
                                    // Edit-Modus beenden
                                    editMode[word] = false;

                                    // JETZT speichern
                                    WordService.update();
                                  } else {
                                    // Edit-Modus aktivieren
                                    editMode[word] = true;
                                  }
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VocScreen.showAddWordDialog(context, widget.language, onWordAdded: () {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteWord(Word word) {
    setState(() {
      WordService.words.remove(word);
      WordService.saveWords();
      if (widget.onChanged != null) widget.onChanged!();
    });
  }

  void _toggleLearned(Word word) {
    setState(() {
      word.learned = !word.learned;
      WordService.saveWords();
      if (widget.onChanged != null) widget.onChanged!();
    });
  }
}
