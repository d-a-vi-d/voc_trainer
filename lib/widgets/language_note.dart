import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/models/language.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';
import 'package:voc_trainer/utils/app_colors.dart';

class LanguageNote extends ConsumerStatefulWidget {
  final Language language;
  const LanguageNote({super.key, required this.language});

  @override
  ConsumerState<LanguageNote> createState() => _LanguageNoteState();
}

class _LanguageNoteState extends ConsumerState<LanguageNote> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.language.notes);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _editing) _save();
  }

  Future<void> _save() async {
    setState(() => _editing = false);
    try {
      await ref.read(wordStateProvider.notifier).updateNotes(widget.language.id!, _controller.text);
    } catch (_) {
      if (!mounted) return;
      _controller.text = widget.language.notes;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not save the note')));
    }
  }

  void _startEditing() {
    if (widget.language.id == null) return; // noch nicht gespeichert
    setState(() => _editing = true);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = widget.language.notes;

    // Zustand 1: leer und nicht in Bearbeitung -> kleiner Balken
    if (!_editing && notes.trim().isEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _startEditing,
        child: SizedBox(
          height: 24,
          child: Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      );
    }

    // Zustand 2 + 3: Kasten (Text anzeigen oder bearbeiten)
    return GestureDetector(
      onTap: _editing ? null : _startEditing,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.tileBackground(context),
          borderRadius: BorderRadius.circular(15),
          border: AppColors.tileBorder(context),
        ),
        child: _editing
            ? TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                minLines: 1,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onTapOutside: (_) => _focusNode.unfocus(),
              )
            : Text(
                notes,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.text(context)),
              ),
      ),
    );
  }
}
