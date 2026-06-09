import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word.dart';
import '../provider/word_state_provider.dart';
import '../utils/error_snackbar.dart';

class WordTile extends ConsumerStatefulWidget {
  final Word word;
  final VoidCallback? onDelete;

  const WordTile({super.key, required this.word, this.onDelete});

  @override
  ConsumerState<WordTile> createState() => _WordTileState();
}

class _WordTileState extends ConsumerState<WordTile> {
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

  Future<void> _toggleLearned() async {
    try {
      await ref.read(wordStateProvider.notifier).toggleLearned(widget.word);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  Future<void> _deleteWord() async {
    try {
      await ref.read(wordStateProvider.notifier).removeWord(widget.word);
      widget.onDelete?.call();
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  Future<void> _saveEdit() async {
    try {
      await ref
          .read(wordStateProvider.notifier)
          .updateWord(
            widget.word,
            term: termController.text.trim(),
            definition: definitionController.text.trim(),
          );
      setState(() => isEditing = false);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
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
                  onPressed: isEditing ? _deleteWord : _toggleLearned,
                ),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.check : Icons.edit,
                    color: isEditing ? Colors.green : Colors.grey,
                  ),
                  onPressed: isEditing ? _saveEdit : () => setState(() => isEditing = true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
