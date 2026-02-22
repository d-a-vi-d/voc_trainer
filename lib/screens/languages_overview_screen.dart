import 'package:flutter/material.dart';
import 'package:voc_trainer/services/word_service.dart';

class LanguagesOverviewScreen extends StatefulWidget {
  //final

  final Future<void> Function(int index) onDeleteLanguage;
  const LanguagesOverviewScreen({super.key, required this.onDeleteLanguage});

  State<LanguagesOverviewScreen> createState() =>
      _LanguagesOverviewScreenState();
}

class _LanguagesOverviewScreenState extends State<LanguagesOverviewScreen> {
  bool editMode = false;
  final Map<int, String> languageNameChanges = {};

  Future<void> _toggleEditMode() async {
    if (editMode) {
      for (final entry in languageNameChanges.entries) {
        try {
          await WordService.renameLanguage(entry.key, entry.value);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              //duration: Duration(seconds: 3),
            ),
          );
        }
      }
      languageNameChanges.clear();
    }
    setState(() {
      editMode = !editMode;
    });
  }

  Widget _buildLanguagetile(int index) {
    int learned = WordService.getWordsForLanguage(
      WordService.languages[index],
    ).where((w) => w.learned).length.toInt();
    int total = WordService.getWordsForLanguage(
      WordService.languages[index],
    ).length.toInt();
    double progress = learned / total;
    final languageController = TextEditingController(
      text: WordService.languages[index],
    );
    return Container(
      height: 70,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.white],
          stops: total == 0
              ? [0, 0]
              : progress == 0
              ? [0, 0]
              : progress == 1
              ? [1, 1]
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
            Text(WordService.languages[index], style: TextStyle(fontSize: 20)),
            Text('${learned} / ${total}', style: TextStyle(fontSize: 20)),
          ],

          if (editMode) ...[
            IntrinsicWidth(
              child: TextField(
                controller: languageController,

                decoration: const InputDecoration(hintText: 'Language'),
                onChanged: (_) {
                  final String newLanguageName = languageController.text;
                  languageNameChanges[index] = newLanguageName;
                },
                style: TextStyle(fontSize: 20),
              ),
            ),
            IconButton(
              onPressed: () async {
                await widget.onDeleteLanguage(index);
                setState(() {
                  editMode = false;
                });
              },
              icon: Icon(Icons.delete),
              iconSize: 30,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 8),
        title: Text("Your Languages"),
        actions: [
          IconButton(
            onPressed: _toggleEditMode,
            icon: editMode ? Icon(Icons.check) : Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            children: <Widget>[
              for (
                int index = 0;
                index < WordService.languages.length;
                index += 1
              )
                Container(child: _buildLanguagetile(index)),
            ],
          ),
        ),
      ),
    );
  }
}
