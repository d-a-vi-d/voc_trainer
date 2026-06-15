import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/models/word_state.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';
import 'package:voc_trainer/utils/special_exception.dart';
import '../main.dart';
import 'dart:typed_data';

class BackupService {
  static Future<bool> exportBackup(WordState state) async {
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/word_backup.json');

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

    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(backupData)));

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Backup speichern',
      fileName: 'word_backup.json',
      bytes: bytes,
    );

    // path == null  ->  Nutzer hat den SAF-Dialog abgebrochen
    return path != null;
  }

  //   await file.writeAsString(jsonEncode(backupData));
  //   final success = await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  //   print(success);
  // }

  static Future<bool> importBackup(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null) return false;

    final content = await File(result.files.single.path!).readAsString();
    final decoded = jsonDecode(content);

    final importedLanguages = List<String>.from(decoded['languages']);
    final importedWords = List<Map<String, dynamic>>.from(decoded['words']);

    //final labelToId = {for (final l in importedLanguages) l['label'] as String: l['id'] as int};

    for (final w in importedWords) {
      if (!importedLanguages.contains(w['language']))
        throw SpecialException(errorMessage: "Was bei den languages ist fehlgeschlagen");
    }
    // Alles löschen
    await supabase.from('words').delete().neq('id', 0);
    await supabase.from('languages').delete().neq('id', 0);

    // Languages einfügen + IDs zurückbekommen
    final langResponse = await supabase
        .from('languages')
        .insert(importedLanguages.map((l) => {'label': l}).toList())
        .select('id, label');

    final labelToId = {for (final l in langResponse) l['label'] as String: l['id'] as int};

    const batchSize = 1000;
    int offset = 0;

    // Words einfügen
    while (offset < importedWords.length) {
      final end = (offset + batchSize).clamp(0, importedWords.length);
      final chunk = importedWords.sublist(offset, end);

      await supabase
          .from('words')
          .insert(
            chunk
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

      offset += batchSize;
    }
    ref.invalidate(wordStateProvider);
    return true;
  }
}
