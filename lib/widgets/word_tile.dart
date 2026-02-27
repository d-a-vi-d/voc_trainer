import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class WordTile extends StatefulWidget {
  final Word word;
  final VoidCallback? onDelete; // <-- callback hinzufügen

  const WordTile({super.key, required this.word, this.onDelete});

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  late TextEditingController termController;
  late TextEditingController definitionController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    termController = TextEditingController(text: widget.word.term);
    definitionController = TextEditingController(text: widget.word.definition);
  }

  @override
  void dispose() {
    termController.dispose();
    definitionController.dispose();
    super.dispose();
  }

  void _toggleLearned() {
    setState(() {
      widget.word.learned = !widget.word.learned;
      WordService.saveWords();
    });
  }

  void _deleteWord() async {
    await WordService.removeWord(widget.word);
    if (widget.onDelete != null) widget.onDelete!(); // <-- HomeScreen benachrichtigen
  }

  void _saveEdit() {
    setState(() {
      widget.word.term = termController.text.trim();
      widget.word.definition = definitionController.text.trim();
      isEditing = false;
      WordService.update();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          controller: termController,
                          decoration: const InputDecoration(hintText: 'Term'),
                        ),
                        TextField(
                          controller: definitionController,
                          decoration: const InputDecoration(hintText: 'Definition'),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.word.term, style: const TextStyle(fontSize: 16)),
                        Text(widget.word.definition, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
            ),
            Column(
              children: [
                IconButton(
                  icon: isEditing
                      ? const Icon(Icons.delete, color: Colors.red)
                      : Icon(
                          widget.word.learned ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: widget.word.learned ? Colors.green : Colors.grey,
                        ),
                  onPressed: () {
                    if (isEditing) {
                      _deleteWord();
                    } else {
                      _toggleLearned();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    color: isEditing ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    if (isEditing) {
                      _saveEdit();
                    } else {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
