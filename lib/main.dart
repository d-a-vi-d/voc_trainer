import 'package:flutter/material.dart';
import 'screens/voc_screen.dart';
import 'screens/learn_mode_screen.dart';
import 'package:voc_trainer/services/word_service.dart';
import 'models/word.dart';
import 'package:dotted_border/dotted_border.dart';


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
      themeMode: ThemeMode.light, // <--- always light mode
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
  int selectedLangIndex = 0;
  int? draggingIndex;
  int? dropPreviewIndex;
  bool isDraggingMode = false;
  DateTime? dragStartTime;

  List<String> get languages {
    final langs = WordService.words.map((w) => w.language).where((l) => l.isNotEmpty).toSet();
    if (!langs.contains('Englisch')) langs.add('Englisch');
    return langs.toList();
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
              if (newLang.isNotEmpty && !languages.contains(newLang)) {
                WordService.words.add(Word(word: '', translation: '', language: newLang));
                WordService.saveWords();
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
        content: Text('Möchtest du "$lang" und alle zugehörigen Wörter wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              WordService.words.removeWhere((w) => w.language == lang);
              WordService.saveWords();
              setState(() {
                selectedLangIndex = 0;
              });
              Navigator.pop(context);
            },
            child: const Text('Löschen', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langList = List.from(languages);
    final currentLang = langList.isNotEmpty ? langList[selectedLangIndex] : 'Englisch';
    const Color mainGreen = Color(0xFF4CB78A);
    const Color accentGreen = Color(0xFF7DD8A7);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [mainGreen, accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        currentLang,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: mainGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
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
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2F2C9), Color(0xFFF9F9F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: VocScreen(
          language: currentLang,
          onChanged: () => setState(() {}),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    langList.length + (isDraggingMode && dropPreviewIndex != null ? 1 : 0),
                    (i) {
                      // Show DottedBorder at dropPreviewIndex
                      if (isDraggingMode && dropPreviewIndex == i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DottedBorder(
                             options: RoundedRectDottedBorderOptions(
                              color: Colors.green,
                              strokeWidth: 2,
                              dashPattern: [6, 3],
                              radius: const Radius.circular(20),
                            ),

                            child: Container(
                              width: 100,
                              height: 40,
                            ),
                          ),
                        );
                      }
                      // Adjust index if DottedBorder is inserted
                      final realIndex = (isDraggingMode && dropPreviewIndex != null && i > dropPreviewIndex!) ? i - 1 : i;
                      if (realIndex >= langList.length) return const SizedBox.shrink();
                      final lang = langList[realIndex];
                      final isSelected = selectedLangIndex == realIndex;
                      final isDragging = draggingIndex == realIndex && isDraggingMode;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: isDragging
                            ? Draggable<int>(
                                data: realIndex,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Chip(
                                    label: Text(
                                      lang,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.green,
                                    labelStyle: const TextStyle(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  ),
                                ),
                                child: const SizedBox.shrink(),
                                onDragEnd: (details) {
                                  setState(() {
                                    draggingIndex = null;
                                    isDraggingMode = false;
                                    dropPreviewIndex = null;
                                  });
                                },
                              )
                            : DragTarget<int>(
                                onWillAccept: (fromIndex) {
                                  if (!isDraggingMode || fromIndex == realIndex) return false;
                                  setState(() => dropPreviewIndex = i);
                                  return true;
                                },
                                onLeave: (data) {
                                  setState(() => dropPreviewIndex = null);
                                },
                                onAccept: (fromIndex) {
                                  setState(() {
                                    final movedLang = langList.removeAt(fromIndex);
                                    langList.insert(i, movedLang);
                                    selectedLangIndex = langList.indexOf(movedLang);
                                    draggingIndex = null;
                                    isDraggingMode = false;
                                    dropPreviewIndex = null;
                                  });
                                },
                                builder: (context, candidateData, rejectedData) => GestureDetector(
                                  onLongPressStart: (_) {
                                    dragStartTime = DateTime.now();
                                  },
                                  onLongPressEnd: (_) {
                                    if (dragStartTime != null &&
                                        DateTime.now().difference(dragStartTime!) > const Duration(milliseconds: 900)) {
                                      setState(() {
                                        draggingIndex = realIndex;
                                        isDraggingMode = true;
                                        dropPreviewIndex = realIndex;
                                      });
                                    }
                                  },
                                  onTap: () {
                                    if (!isDraggingMode) {
                                      setState(() => selectedLangIndex = realIndex);
                                    }
                                  },
                                  child: Chip(
                                    label: Text(
                                      lang,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    backgroundColor: isSelected ? Colors.green : Colors.grey[300],
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 32, color: Colors.green),
                    onPressed: _addLanguageDialog,
                    tooltip: 'Sprache hinzufügen',
                  ),
                ],
              ),
            ),
            // Mülleimer nur im Drag-Modus sichtbar und als DragTarget
            if (isDraggingMode && draggingIndex != null)
              Positioned(
                child: DragTarget<int>(
                  builder: (context, candidateData, rejectedData) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 36),
                  ),
                  onWillAccept: (fromIndex) => true,
                  onAccept: (fromIndex) {
                    setState(() {
                      _deleteLanguage(langList[fromIndex]);
                      draggingIndex = null;
                      dropPreviewIndex = null;
                      isDraggingMode = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: isDraggingMode && draggingIndex != null
          ? DragTarget<int>(
              builder: (context, candidateData, rejectedData) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 36),
              ),
              onWillAccept: (fromIndex) => true,
              onAccept: (fromIndex) {
                setState(() {
                  _deleteLanguage(langList[fromIndex]);
                  draggingIndex = null;
                  dropPreviewIndex = null;
                  isDraggingMode = false;
                });
              },
            )
          : null,
    );
  }
}