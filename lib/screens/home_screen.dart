import 'package:flutter/material.dart';
import 'voc_screen.dart';
import 'learn_mode_screen.dart';
import '../services/word_service.dart';

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

  void _deleteLanguageDialog(int index) {
    final lang = WordService.languages[index];
    showDialog(
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
    final currentLang = WordService.languages[selectedLangIndex];

    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 8),
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
          ),
        ],
      ),
      body: VocScreen(language: currentLang),
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
              final plusIndex = WordService.languages.length + 1;

              if (newIndex == plusIndex) {
                _deleteLanguageDialog(index);
                return;
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
    );
  }
}
