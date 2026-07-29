import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/word.dart';
import '../provider/word_state_provider.dart';
import '../utils/error_snackbar.dart';

class WordTile extends ConsumerWidget {
  static const double _iconButtonSize = 48; // Material-Standard, explizit gesetzt statt geraten
  static const double contentHeight = _iconButtonSize * 2; // 96
  static const double margin = 8; // Card: vertical 4 oben + 4 unten
  static const double itemExtent = contentHeight + margin; // 104

  final Word word;
  final VoidCallback? onDelete;

  const WordTile({super.key, required this.word, this.onDelete});

  Future<void> _toggleLearned(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(wordStateProvider.notifier).toggleLearned(word);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          height: contentHeight,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      word.term,
                      style: const TextStyle(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      word.definition,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: const Size(_iconButtonSize, _iconButtonSize),
                    ),
                    icon: Icon(
                      word.learned ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: word.learned ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => _toggleLearned(ref, context),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: const Size(_iconButtonSize, _iconButtonSize),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => showDialog(
                      barrierDismissible: false,

                      context: context,
                      builder: (_) => _EditWordDialog(word: word, onDeleted: onDelete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditWordDialog extends ConsumerStatefulWidget {
  final Word word;
  final VoidCallback? onDeleted;

  const _EditWordDialog({required this.word, this.onDeleted});

  @override
  ConsumerState<_EditWordDialog> createState() => _EditWordDialogState();
}

class _EditWordDialogState extends ConsumerState<_EditWordDialog> {
  late final TextEditingController termController;
  late final TextEditingController definitionController;

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

  Future<void> _save() async {
    final term = termController.text.trim();
    final definition = definitionController.text.trim();
    if (term.isEmpty || definition.isEmpty) return;
    try {
      await ref
          .read(wordStateProvider.notifier)
          .updateWord(
            widget.word,
            term: termController.text.trim(),
            definition: definitionController.text.trim(),
          );
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  Future<void> _delete() async {
    try {
      await ref.read(wordStateProvider.notifier).removeWord(widget.word);
      widget.onDeleted?.call();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) context.showError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(child: Text('Edit word: \n${widget.word.definition}')),
          IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            TextButton(
              onPressed: _delete,
              child: const Text('Löschen', style: TextStyle(color: Colors.red)),
            ),
            // TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
            TextButton(onPressed: _save, child: const Text('Speichern')),
          ],
        ),
      ],
    );
  }
}
