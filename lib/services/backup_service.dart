import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voc_trainer/models/word_state.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';
import '../main.dart';

class BackupService {
  static Future<void> exportBackup(WordState state) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/word_backup.json');

    final backupData = {
      "version": 1,
      "languages": state.languages.map((l) => l.label).toList(),
      "words": state.words
          .map(
            (w) => {
              'term': w.term,
              'definition': w.definition,
              'language': w.language,
              'learned': w.learned,
            },
          )
          .toList(),
    };

    await file.writeAsString(jsonEncode(backupData));
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  static Future<void> importBackup(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null) return;

    final content = await File(result.files.single.path!).readAsString();
    final decoded = jsonDecode(content);

    final importedLanguages = List<String>.from(decoded['languages']);
    final importedWords = List<Map<String, dynamic>>.from(decoded['words']);

    // Alles löschen
    await supabase.from('words').delete().neq('id', 0);
    await supabase.from('languages').delete().neq('id', 0);

    // Languages einfügen + IDs zurückbekommen
    final langResponse = await supabase
        .from('languages')
        .insert(importedLanguages.map((l) => {'label': l}).toList())
        .select('id, label');

    final labelToId = {for (final l in langResponse) l['label'] as String: l['id'] as int};

    // Words einfügen
    await supabase
        .from('words')
        .insert(
          importedWords
              .map(
                (w) => {
                  'term': w['term'],
                  'definition': w['definition'],
                  'learned': w['learned'] ?? false,
                  'language_id': labelToId[w['language']],
                },
              )
              .toList(),
        );

    ref.invalidate(wordStateProvider);
  }
}
