import 'package:flutter/material.dart';
import 'package:voc_trainer/screens/languages_overview_screen.dart';
import 'learn_screen.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<Word, bool> editMode = {};
  int selectedLangIndex = 0;
  Future<void> showAddWordDialog(
    BuildContext context,
    String currentLanguage, {
    VoidCallback? onWordAdded,
  }) async {
    bool alreadyEnteredAWord = false;
    final wordController = TextEditingController();
    final translationController = TextEditingController();
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Neues Wort für $currentLanguage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
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
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(alreadyEnteredAWord ? 'Fertig' : 'Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () {
                      final word = wordController.text.trim();
                      final translation = translationController.text.trim();
                      if (word.isNotEmpty && translation.isNotEmpty) {
                        WordService.words.add(
                          Word(
                            word: word,
                            translation: translation,
                            language: currentLanguage,
                          ),
                        );
                        WordService.saveWords();
                        if (onWordAdded != null) onWordAdded();
                        //Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Wort hinzugefügt')),
                        );
                        wordController.clear();
                        translationController.clear();
                        setState(() {
                          alreadyEnteredAWord = true;
                        });
                      }
                    },
                    child: const Text('Hinzufügen'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

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
          autofocus: true,
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

  Future<void> _deleteLanguageDialog(int index) async {
    final lang = WordService.languages[index];
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache löschen'),
        content: Text(
          'Möchtest du "$lang" und alle zugehörigen Wörter wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () async {
              if (index <= selectedLangIndex) {
                selectedLangIndex -= 1;
              }
              await WordService.removeLanguage(lang);
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
    child: Text(
      WordService.languages[index],
      style: TextStyle(
        fontSize: 20,
        fontWeight: index == selectedLangIndex
            ? FontWeight.bold
            : FontWeight.normal,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final currentLanguage = WordService.languages[selectedLangIndex];
    List<Word> words = WordService.getWordsForLanguage(currentLanguage);
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 8),
        title: Text(currentLanguage),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LanguagesOverviewScreen(
                    onDeleteLanguage: _deleteLanguageDialog,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LearnScreen(language: currentLanguage),
                ),
              );
            },
            child: const Text('Lernen'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: 75,
              ),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                final isEditing = editMode[word] ?? false;
                final wordController = TextEditingController(text: word.word);
                final translationController = TextEditingController(
                  text: word.translation,
                );
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
                                      decoration: const InputDecoration(
                                        hintText: 'Word',
                                      ),
                                      onSubmitted: (_) {
                                        word.word = wordController.text;
                                      },
                                    ),
                                    TextField(
                                      controller: translationController,
                                      decoration: const InputDecoration(
                                        hintText: 'Translation',
                                      ),
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
                                      color: word.learned
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                              onPressed: () {
                                setState(() {
                                  if (isEditing) {
                                    WordService.removeWord(word);
                                  } else {
                                    word.learned = !word.learned;
                                    WordService.saveWords();
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
                                    word.translation =
                                        translationController.text;
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: SizedBox(
          height: 90,
          child: ReorderableListView(
            proxyDecorator:
                (Widget child, int index, Animation<double> animation) =>
                    _buildLanguagetile(index),
            scrollDirection: Axis.horizontal,
            onReorder: (int index, int newIndex) {
              if (newIndex >= WordService.languages.length) {
                newIndex = WordService.languages.length;
              }

              setState(() {
                if (index < newIndex) newIndex -= 1;
                final previouslySelected =
                    WordService.languages[selectedLangIndex];
                final String item = WordService.languages.removeAt(index);
                WordService.languages.insert(newIndex, item);

                selectedLangIndex = WordService.languages.indexOf(
                  previouslySelected,
                );
                if (selectedLangIndex == -1) selectedLangIndex = 0;

                WordService.saveLanguages();
              });
            },
            children: <Widget>[
              for (
                int index = 0;
                index < WordService.languages.length;
                index += 1
              )
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLangIndex = index;
                    });
                  },
                  key: Key('$index'),
                  child: _buildLanguagetile(index),
                ),
              GestureDetector(
                onTap: () {
                  _addLanguageDialog();
                  setState(() {});
                },
                onLongPress: () {},
                key: Key('add/ delete Button'),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddWordDialog(
            context,
            currentLanguage,
            onWordAdded: () {
              setState(() {});
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
