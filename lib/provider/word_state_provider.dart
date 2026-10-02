import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:voc_trainer/models/language.dart';
import 'package:voc_trainer/models/word.dart';
import 'package:voc_trainer/models/word_state.dart';
import 'package:voc_trainer/utils/special_exception.dart';
import '../main.dart';
import 'auth_provider.dart';

part 'word_state_provider.g.dart';

@riverpod
class WordStateNotifier extends _$WordStateNotifier {
  @override
  Future<WordState> build() async {
    // Neu laden, sobald sich der eingeloggte User ändert (Login/Logout)
    final userId =
        ref.watch(authProvider.select((s) => s.value?.session?.user.id)) ??
        supabase.auth.currentUser?.id;
    if (userId == null) {
      return WordState(words: [], languages: []);
    }

    final languagesRaw = await supabase
        .from('languages')
        .select('id, label')
        .order('position')
        .order('id'); // Tie-Breaker, damit die Reihenfolge immer eindeutig ist

    final languages = languagesRaw.map((l) => Language.fromJson(l)).toList();

    // final wordsRaw = await supabase.from('words').select('*, languages(label)').limit(10000);
    // final words = wordsRaw.map((w) => Word.fromJson(w)).toList();
    List<Map<String, dynamic>> allWordsRaw = [];
    const batchSize = 1000;
    int offset = 0;

    while (true) {
      final batch = await supabase
          .from('words')
          .select('*, languages(label)')
          .order('id')
          .range(offset, offset + batchSize - 1);

      allWordsRaw.addAll(batch);
      if (batch.length < batchSize) break;
      offset += batchSize;
    }

    final words = allWordsRaw.map((w) => Word.fromJson(w)).toList();

    return WordState(words: words, languages: languages);
  }

  Future<void> addWord(Word word) async {
    final previous = state.requireValue;
    // 1. State sofort updaten
    state = AsyncData(WordState(words: [...previous.words, word], languages: previous.languages));
    try {
      // 2. Supabase — gibt echtes Objekt mit DB-id zurück
      final response = await supabase
          .from('words')
          .insert(word.toJson())
          .select('*, languages(label)')
          .single();
      final inserted = Word.fromJson(response);
      // 3. Ersetze optimistisches Objekt durch echtes
      state = AsyncData(
        WordState(words: [...previous.words, inserted], languages: previous.languages),
      );
    } catch (e) {
      state = AsyncData(previous); // Rollback
      rethrow; // UI fängt den Error
    }
  }

  Future<void> updateWord(Word word, {required String term, required String definition}) async {
    final previous = state.requireValue;
    final updated = previous.words
        .map(
          (w) => w.id == word.id
              ? Word(
                  id: w.id,
                  term: term,
                  definition: definition,
                  languageId: w.languageId,
                  learned: w.learned,
                  languages: w.languages,
                )
              : w,
        )
        .toList();
    state = AsyncData(WordState(words: updated, languages: previous.languages));
    try {
      await supabase
          .from('words')
          .update({'term': term, 'definition': definition})
          .eq('id', word.id!);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> removeWord(Word word) async {
    final previous = state.requireValue;
    // 1. State sofort updaten
    state = AsyncData(
      WordState(
        words: previous.words.where((w) => w != word).toList(),
        languages: previous.languages,
      ),
    );
    if (word.id == null) return;
    try {
      // 2. Supabase — gibt echtes Objekt mit DB-id zurück
      await supabase.from('words').delete().eq('id', word.id!);
    } catch (e) {
      state = AsyncData(previous); // Rollback
      rethrow; // UI fängt den Error
    }
  }

  //-------------LANGUAGES-----------------

  Future<void> addLanguage(String language) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    final previous = state.requireValue;
    // 1. State sofort updaten
    state = AsyncData(
      WordState(
        words: previous.words,
        languages: [
          ...previous.languages,
          Language(label: language),
        ],
      ),
    );
    try {
      // 2. Supabase — gibt echtes Objekt mit DB-id zurück
      final response = await supabase
          .from('languages')
          .insert({'label': language, 'user_id': supabase.auth.currentUser!.id})
          .select('id, label')
          .single();

      // 3. Ersetze optimistisches Objekt durch echtes
      final inserted = Language.fromJson(response);

      state = AsyncData(
        WordState(words: previous.words, languages: [...previous.languages, inserted]),
      );
    } catch (e) {
      state = AsyncData(previous); // Rollback
      rethrow; // UI fängt den Error
    }
  }

  Future<void> removeLanguage(Language language) async {
    final previous = state.requireValue;
    // 1. State sofort updaten
    state = AsyncData(
      WordState(
        words: previous.words.where((w) => w.languageId != language.id).toList(),
        languages: previous.languages.where((l) => l.id != language.id).toList(),
      ),
    );
    if (language.id == null) return;
    try {
      // 2. Supabase — gibt echtes Objekt mit DB-id zurück
      await supabase.from('languages').delete().eq('id', language.id!);
    } catch (e) {
      state = AsyncData(previous); // Rollback
      rethrow; // UI fängt den Error
    }
  }

  Future<void> renameLanguage(int index, String newLanguageName) async {
    //String oldLanguageName = WordService.languages[index];
    final previous = await future;

    if (newLanguageName.isEmpty) {
      return;
    }
    //checken ob Name existiert
    //if (WordService.languages.contains(newLanguageName)) {

    if (previous.languages.any((l) => l.label == newLanguageName)) {
      throw SpecialException(errorMessage: "There is already a language with this name!");
    }
    final oldLanguage = previous.languages[index];
    final updated = [...previous.languages];
    updated[index] = Language(id: oldLanguage.id, label: newLanguageName);
    // 1. State sofort updaten
    state = AsyncData(WordState(words: previous.words, languages: updated));

    try {
      await supabase.from('languages').update({'label': newLanguageName}).eq('id', oldLanguage.id!);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> reorderLanguages(int oldIndex, int newIndex) async {
    final previous = state.requireValue;
    final count = previous.languages.length;

    // Der "+"-Button ist in der UI Teil der Reorder-Liste und darf nichts auslösen.
    if (oldIndex < 0 || oldIndex >= count) return;
    // Eine Sprache, die noch gespeichert wird, hat noch keine id.
    if (previous.languages.any((l) => l.id == null)) return;

    final target = newIndex.clamp(0, count - 1);
    if (target == oldIndex) return;

    final reordered = [...previous.languages];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(target, moved);

    // 1. State sofort updaten
    state = AsyncData(WordState(words: previous.words, languages: reordered));
    try {
      // 2. Supabase: komplette Reihenfolge in einer atomaren Anfrage speichern
      await supabase.rpc(
        'reorder_languages',
        params: {'ordered_ids': reordered.map((l) => l.id!).toList()},
      );
    } catch (e) {
      state = AsyncData(previous); // Rollback
      rethrow; // UI fängt den Error
    }
  }

  Future<void> toggleLearned(Word word) async {
    final previous = state.requireValue;
    final updated = previous.words
        .map(
          (w) => w == word
              ? Word(
                  id: w.id,
                  term: w.term,
                  definition: w.definition,
                  languageId: w.languageId,
                  learned: !w.learned,
                  languages: w.languages,
                )
              : w,
        )
        .toList();
    state = AsyncData(WordState(words: updated, languages: previous.languages));
    try {
      await supabase.from('words').update({'learned': !word.learned}).eq('id', word.id!);
    } catch (e) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}
