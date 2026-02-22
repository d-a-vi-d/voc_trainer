import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class BackupService {
  // EXPORT
  static Future<void> exportBackup() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/word_backup.json');

    final backupData = {
      "version": 1,
      "languages": WordService.languages,
      "words": WordService.words.map((w) => w.toJson()).toList(),
    };

    await file.writeAsString(jsonEncode(backupData));
  }

  // IMPORT (REPLACE)
  static Future<void> importBackup() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);
    final content = await file.readAsString();

    final decoded = jsonDecode(content);

    final importedLanguages = List<String>.from(decoded["languages"]);

    final importedWords = (decoded["words"] as List)
        .map((e) => Word.fromJson(e))
        .toList();

    WordService.languages = importedLanguages;
    WordService.words = importedWords;

    await WordService.saveLanguages();
    await WordService.saveWords();
  }
}
