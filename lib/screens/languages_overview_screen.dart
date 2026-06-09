import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/models/language.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';

class LanguagesOverviewScreen extends ConsumerStatefulWidget {
  final Future<void> Function(Language language) onDeleteLanguage;
  const LanguagesOverviewScreen({super.key, required this.onDeleteLanguage});

  @override
  ConsumerState<LanguagesOverviewScreen> createState() => _LanguagesOverviewScreenState();
}

class _LanguagesOverviewScreenState extends ConsumerState<LanguagesOverviewScreen> {
  bool editMode = false;
  final Map<int, String> languageNameChanges = {};

  Future<void> _toggleEditMode() async {
    if (editMode) {
      for (final entry in languageNameChanges.entries) {
        try {
          await ref.read(wordStateProvider.notifier).renameLanguage(entry.key, entry.value);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
      languageNameChanges.clear();
    }
    setState(() => editMode = !editMode);
  }

  Widget _buildLanguagetile(int index, List<Language> languages, List words) {
    final language = languages[index];
    final wordsForLang = words.where((w) => w.languageId == language.id).toList();
    final learned = wordsForLang.where((w) => w.learned).length;
    final total = wordsForLang.length;
    final progress = total == 0 ? 0.0 : learned / total;
    final languageController = TextEditingController(text: language.label);

    return Container(
      height: 70,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.white],
          stops: total == 0 || progress == 0
              ? [0.0, 0.0]
              : progress == 1
              ? [1.0, 1.0]
              : [progress - 0.01, progress + 0.01],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 3),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!editMode) ...[
            Expanded(
              child: Text(
                language.label,
                style: const TextStyle(fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('$learned / $total', style: const TextStyle(fontSize: 20)),
          ],
          if (editMode) ...[
            IntrinsicWidth(
              child: TextField(
                controller: languageController,
                decoration: const InputDecoration(hintText: 'Language'),
                style: const TextStyle(fontSize: 20),
                onChanged: (val) => languageNameChanges[index] = val,
              ),
            ),
            IconButton(
              onPressed: () async {
                await widget.onDeleteLanguage(language);
                setState(() => editMode = false);
              },
              icon: const Icon(Icons.delete),
              iconSize: 30,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(wordStateProvider);
    return asyncState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (state) => Scaffold(
        appBar: AppBar(
          actionsPadding: const EdgeInsets.only(right: 8),
          title: const Text("Your Languages"),
          actions: [
            IconButton(onPressed: _toggleEditMode, icon: Icon(editMode ? Icons.check : Icons.edit)),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Column(
              children: [
                for (int i = 0; i < state.languages.length; i++)
                  _buildLanguagetile(i, state.languages, state.words),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
