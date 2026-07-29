import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:voc_trainer/models/language.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';
import 'package:voc_trainer/screens/languages_overview_screen.dart';
import 'learn_screen.dart';
import '../models/word.dart';
import 'package:voc_trainer/screens/settings_screen.dart';
import 'package:voc_trainer/widgets/word_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool searchMode = false;
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  int selectedLangIndex = 0;
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_updateScrollPosition);
  }

  void _updateScrollPosition() {
    if (!scrollController.hasClients) return;
    final atBottom =
        scrollController.offset >=
        scrollController.position.maxScrollExtent - 20; // kleine Toleranz
    if (atBottom != _isAtBottom) {
      setState(() => _isAtBottom = atBottom);
    }
  }

  Future<void> showAddWordDialog(BuildContext context, Language currentLanguage) async {
    final myFocusNode = FocusNode();
    bool alreadyEnteredAWord = false;
    final termController = TextEditingController();
    final definitionController = TextEditingController();
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New word for ${currentLanguage.label}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              focusNode: myFocusNode,
              autofocus: true,
              controller: termController,
              decoration: const InputDecoration(labelText: 'Term'),
            ),
            TextField(
              controller: definitionController,
              decoration: const InputDecoration(labelText: 'Definition'),
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
                      final term = termController.text.trim();
                      final definition = definitionController.text.trim();
                      if (term.isNotEmpty && definition.isNotEmpty) {
                        ref
                            .read(wordStateProvider.notifier)
                            .addWord(
                              Word(
                                term: term,
                                definition: definition,
                                languageId: currentLanguage.id!,
                              ),
                            );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Wort hinzugefügt')));
                        termController.clear();
                        definitionController.clear();
                        setState(() => alreadyEnteredAWord = true);
                        myFocusNode.requestFocus();
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

  void _addLanguageDialog() {
    final addLanguageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache hinzufügen'),
        content: TextField(
          autofocus: true,
          controller: addLanguageController,
          decoration: const InputDecoration(labelText: 'Sprache'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          TextButton(
            onPressed: () {
              final newLang = addLanguageController.text.trim();
              if (newLang.isNotEmpty) {
                ref.read(wordStateProvider.notifier).addLanguage(newLang);
              }
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteLanguageDialog(Language language) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprache löschen'),
        content: Text(
          'Möchtest du "${language.label}" und alle zugehörigen Wörter wirklich löschen?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          TextButton(
            onPressed: () async {
              await ref.read(wordStateProvider.notifier).removeLanguage(language);
              final newLength = ref.read(wordStateProvider).requireValue.languages.length;
              if (selectedLangIndex >= newLength) {
                setState(
                  () => selectedLangIndex = (newLength - 1).clamp(0, double.maxFinite.toInt()),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagetile(int index, List<Language> languages) => Container(
    margin: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: index == selectedLangIndex ? Colors.green : Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.black, width: 3),
    ),
    alignment: Alignment.center,
    padding: const EdgeInsets.all(10),
    child: Text(
      languages[index].label,
      style: TextStyle(
        fontSize: 20,
        fontWeight: index == selectedLangIndex ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );

  List<Word> _getWordsForSearch(List<Word> allWords, Language currentLanguage, String searchInput) {
    return allWords.where((w) {
      if (w.languageId != currentLanguage.id) return false;
      final input = searchInput.toLowerCase();
      return w.term.toLowerCase().contains(input) ||
          w.definition.toLowerCase().contains(input) ||
          partialRatio(input, w.term.toLowerCase()) > 85 ||
          partialRatio(input, w.definition.toLowerCase()) > 85;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(wordStateProvider);
    return asyncState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (state) {
        if (state.languages.isEmpty) {
          return Scaffold(
            body: const Center(child: Text('Keine Sprachen vorhanden')),
            floatingActionButton: FloatingActionButton(
              onPressed: _addLanguageDialog,
              child: const Icon(Icons.add),
            ),
          );
        }
        if (selectedLangIndex >= state.languages.length) {
          selectedLangIndex = state.languages.length - 1;
        }
        final currentLanguage = state.languages[selectedLangIndex];
        final words = searchMode
            ? _getWordsForSearch(state.words, currentLanguage, searchController.text)
            : state.words.where((w) => w.languageId == currentLanguage.id).toList();

        return Scaffold(
          appBar: AppBar(
            actionsPadding: const EdgeInsets.only(right: 8),
            title: Row(
              children: [
                Expanded(child: Text(currentLanguage.label, overflow: TextOverflow.ellipsis)),
                if (searchMode) ...[
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      decoration: const InputDecoration(labelText: 'Suche', isDense: true),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(searchMode ? Icons.close : Icons.search_rounded),
                onPressed: () {
                  if (searchMode) searchController.clear();
                  setState(() => searchMode = !searchMode);
                },
              ),
              if (!searchMode) ...[
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu),
                  onSelected: (value) {
                    if (value == "languages") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              LanguagesOverviewScreen(onDeleteLanguage: _deleteLanguageDialog),
                        ),
                      );
                    } else if (value == "settings") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      ).then((_) => setState(() {}));
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: "languages", child: Text("Languages")),
                    PopupMenuItem(value: "settings", child: Text("Settings")),
                  ],
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LearnScreen(language: currentLanguage.label)),
                  ),
                  child: const Text('Lernen'),
                ),
              ],
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 150),
                  itemCount: words.length,
                  itemExtent: WordTile.itemExtent,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return WordTile(
                      key: ValueKey('${word.languageId}_${word.term}'),
                      word: word,
                      onDelete: () => setState(() {}),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SizedBox(
              height: 90,
              child: ReorderableListView(
                proxyDecorator: (child, index, _) => _buildLanguagetile(index, state.languages),
                scrollDirection: Axis.horizontal,
                onReorderItem: (oldIndex, newIndex) {
                  setState(() {
                    final previouslySelected = state.languages[selectedLangIndex];
                    final langs = [...state.languages];
                    final item = langs.removeAt(oldIndex);
                    langs.insert(newIndex, item);
                    selectedLangIndex = langs.indexOf(previouslySelected);
                    if (selectedLangIndex == -1) selectedLangIndex = 0;
                  });
                },
                children: [
                  for (int i = 0; i < state.languages.length; i++)
                    GestureDetector(
                      key: Key('lang_$i'),
                      onTap: () => setState(() => selectedLangIndex = i),
                      child: _buildLanguagetile(i, state.languages),
                    ),
                  GestureDetector(
                    key: const Key('add_button'),
                    onTap: _addLanguageDialog,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'fab1', // Unique tag required
                onPressed: () {
                  if (!scrollController.hasClients) return;
                  scrollController.jumpTo(
                    _isAtBottom ? 0 : scrollController.position.maxScrollExtent,
                  );
                },
                child: Icon(_isAtBottom ? Icons.arrow_upward : Icons.arrow_downward),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                heroTag: 'fab2', // Unique tag required
                onPressed: () => showAddWordDialog(context, currentLanguage),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_updateScrollPosition);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
