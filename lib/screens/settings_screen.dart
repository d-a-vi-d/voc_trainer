import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/provider/settings_provider.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';
import 'package:voc_trainer/utils/auth_screen.dart';
import 'package:voc_trainer/utils/error_snackbar.dart';
import 'package:voc_trainer/widgets/menu_button.dart';
import '../services/backup_service.dart';
import 'package:voc_trainer/main.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    if (settingsAsync.isLoading || !settingsAsync.hasValue)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (settingsAsync.hasError)
      return const Scaffold(body: Center(child: Text("Fehler beim Laden der Einstellungen")));

    final showAlreadyLearned = settingsAsync.requireValue.showAlreadyLearned;
    final languageMode = settingsAsync.requireValue.languageMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => AuthScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Show already learned?",
              style: TextStyle(
                fontSize: 20, // Größerer Text
                fontWeight: FontWeight.bold, // Fett für bessere Lesbarkeit
                color: Colors.black87, // Weicheres Schwarz
                letterSpacing: 0.5, // Leichter Buchstabenabstand
              ),
            ),
            const SizedBox(height: 6), // Mehr Abstand zwischen Text und Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //show all words button
                MenuButton(
                  onTap: () {
                    // setState(() {
                    //   showOnlyNotLearned = false;
                    // });
                    ref.read(settingsProvider.notifier).setShowAlreadyLearned(true);
                  },
                  selected: showAlreadyLearned,
                  // selected: ref.read(settingsProvider.notifier).value
                  text: "yesss",
                ),
                //only show new words button
                MenuButton(
                  onTap: () {
                    // setState(() {
                    //   showOnlyNotLearned = true;
                    // });
                    ref.read(settingsProvider.notifier).setShowAlreadyLearned(false);
                  },
                  selected: !showAlreadyLearned,
                  text: "nooo",
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              "Which language first?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //show home language first
                MenuButton(
                  onTap: () {
                    // setState(() {
                    //   currentLanguageMode = LanguageMode.HomeLanguageFirst;
                    // });
                    ref.read(settingsProvider.notifier).setLanguageMode(LanguageMode.home);
                  },
                  selected: languageMode == LanguageMode.home,
                  text: "home",
                ),
                //show foreign language first
                MenuButton(
                  onTap: () {
                    // setState(() {
                    //   currentLanguageMode = LanguageMode.ForeignLanguageFirst;
                    // });
                    ref.read(settingsProvider.notifier).setLanguageMode(LanguageMode.foreign);
                  },
                  selected: languageMode == LanguageMode.foreign,
                  text: "foreign",
                ),
                //random language first
                MenuButton(
                  onTap: () {
                    // setState(() {
                    //   currentLanguageMode = LanguageMode.RandomLanguageFirst;
                    // });
                    ref.read(settingsProvider.notifier).setLanguageMode(LanguageMode.random);
                  },
                  selected: languageMode == LanguageMode.random,
                  text: "random",
                ),
              ],
            ),
            const SizedBox(height: 30), // Abstand zu vorherigen Einstellungen
            Text(
              "Backup",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Backup erstellen
                MenuButton(
                  onTap: () async {
                    try {
                      final saved = await BackupService.exportBackup(
                        ref.read(wordStateProvider).requireValue,
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            saved ? "Backup erfolgreich erstellt!" : "Backup abgebrochen",
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      context.showError(e);
                    }
                  },

                  text: "Erstellen",
                ),
                const SizedBox(width: 10),
                // Backup laden
                MenuButton(
                  onTap: () async {
                    try {
                      final loaded = await BackupService.importBackup(ref);
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            loaded ? "Backup erfolgreich geladen!" : "Laden abgebrochen",
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      context.showError(e);
                    }
                  },

                  text: "Laden",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
