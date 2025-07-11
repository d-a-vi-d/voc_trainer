import 'package:flutter/material.dart';
import '../services/word_service.dart';
import '../models/word.dart';
import '../screens/learn_mode_screen.dart';

class VocScreen extends StatefulWidget {
  final String language;

  const VocScreen({super.key, required this.language});

  
  @override
    State<VocScreen> createState() => _VocScreenState();
  }


class _VocScreenState extends State<VocScreen> {
  final Map<Word, bool> editMode = {}; // pro Wort merken
  
  @override
  Widget build(BuildContext context) {
    List<Word> words = WordService.getWordsForLanguage(widget.language);

    return Scaffold(
      appBar: AppBar(title: const Text('Lernen')),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.language,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LearnModeScreen(language: widget.language),
                      ),
                    );
                  },
                  child: const Text('Lernen'),
                )
              ],
            ),
          ),
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
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                    ),
                              onPressed: () {
                                setState(() {
                                  if (isEditing) {
                                    WordService.removeWord(word);
                                  } else {
                                    word.learned = !word.learned;
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
    );
  }
}
