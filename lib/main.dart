import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'services/word_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WordService.load();
  await Supabase.initialize(url: 'https://kvlspkkccigktqtwpzug.supabase.co', anonKey: 'sb_publishable_9_EfB6LSyfHNAE3YqQThnw_ctnO8fh-');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vokabeltrainer',
      theme: ThemeData(primarySwatch: Colors.green),
      home: StreamBuilder<AuthState>(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          final session = supabase.auth.currentSession;
          if (session != null) {
            return const HomeScreen();
          } else {
            return const SignupScreen();
          }
        },
      ),
      //isLoggedIn ? const HomeScreen() : const SignupScreen(),
    );
  }
}



// supabase + login
  //https://supabase.com/docs/reference/dart/select
  //https://supabase.com/dashboard/project/kvlspkkccigktqtwpzug/settings/api-keys

// state management (wann wörter updaten - zb "sterne exkludieren")
  // always foreign language when going into learning mode - should regard the settings (shared_preferences)
  // is aber geil wenn man das letzte wort noch da hat

// Notizen Funktion


// ✔️renaming a language - checking the check in the appbar - new language name not saved
// ✔️epische Suchfunktion mit similarities


// ✅sprachen overview screen
// ✅cycle managen (progress bar zeigt an wo im cycle man ist, "durchgang fertig - neu beginnen?")
// ✅Suchfunktion
// ✅which language first - nothing is green
// ✅"Übersicht" Button so machen wie Pfeil zurück Button

