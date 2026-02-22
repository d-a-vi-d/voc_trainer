import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voc_trainer/screens/login_screen.dart';
import 'package:voc_trainer/widgets/menu_button.dart';
import '../services/backup_service.dart';

enum LanguageMode {
  HomeLanguageFirst,
  ForeignLanguageFirst,
  RandomLanguageFirst,
}

final supabase = Supabase.instance.client;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showOnlyNotLearned = true;
  LanguageMode currentLanguageMode = LanguageMode.HomeLanguageFirst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
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
                    setState(() {
                      showOnlyNotLearned = false;
                    });
                  },
                  selected: !showOnlyNotLearned,
                  text: "yesss",
                ),
                //only show new words button
                MenuButton(
                  onTap: () {
                    setState(() {
                      showOnlyNotLearned = true;
                    });
                  },
                  selected: showOnlyNotLearned,
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
                    setState(() {
                      currentLanguageMode = LanguageMode.HomeLanguageFirst;
                    });
                  },
                  selected:
                      currentLanguageMode == LanguageMode.HomeLanguageFirst,
                  text: "home",
                ),
                //show foreign language first
                MenuButton(
                  onTap: () {
                    setState(() {
                      currentLanguageMode = LanguageMode.ForeignLanguageFirst;
                    });
                  },
                  selected:
                      currentLanguageMode == LanguageMode.ForeignLanguageFirst,
                  text: "foreign",
                ),
                //random language first
                MenuButton(
                  onTap: () {
                    setState(() {
                      currentLanguageMode = LanguageMode.RandomLanguageFirst;
                    });
                  },
                  selected:
                      currentLanguageMode == LanguageMode.RandomLanguageFirst,
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
                      await BackupService.exportBackup();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Backup erfolgreich erstellt!"),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fehler beim Backup erstellen: $e"),
                        ),
                      );
                    }
                  },
                  selected: false, // kann man dynamisch machen, falls nötig
                  text: "Erstellen",
                ),
                const SizedBox(width: 10),
                // Backup laden
                MenuButton(
                  onTap: () async {
                    try {
                      await BackupService.importBackup();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Backup erfolgreich geladen!"),
                        ),
                      );
                      setState(
                        () {},
                      ); // Optional, falls UI nach Import aktualisiert werden soll
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Fehler beim Backup laden: $e")),
                      );
                    }
                  },
                  selected: false, // kann man dynamisch machen, falls nötig
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
