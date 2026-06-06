import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voc_trainer/screens/home_screen.dart';
import 'package:voc_trainer/screens/login_screen.dart';
import 'dart:async';

import '../main.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  late final AppLinks _appLinks;
  StreamSubscription? _linkSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _appLinks = AppLinks();

    final uri = await _appLinks.getInitialLink();
    if (uri != null) await _handleUri(uri);

    _linkSub = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri);
    });
  }

  Future<void> _handleUri(Uri uri) async {
    if (uri.host == 'login-callback') {
      Supabase.instance.client.auth.getSessionFromUrl(uri);
      // navigieren z.B. Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    //!final userAsync = ref.watch(authProvider);

    //!if (userAsync == null) return const LoginScreen();

    // if (familyAsync.hasError || profileAsync.hasError) {
    //   return Scaffold(
    //     body: Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Text('Fehler beim Laden'),
    //           ElevatedButton(
    //             onPressed: () {
    //               ref.invalidate(familyProvider);
    //               ref.invalidate(profileProvider);
    //             },
    //             child: const Text('Erneut versuchen'),
    //           ),
    //           const SizedBox(height: 10),
    //           ElevatedButton(
    //             onPressed: () async {
    //               try {
    //                 await supabase.auth.signOut();
    //               } catch (_) {
    //                 await supabase.auth.signOut(scope: SignOutScope.local);
    //               }
    //             },
    //             child: const Text('Ausloggen'),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    // // Warten bis BEIDE geladen sind
    // if (!familyAsync.hasValue || !profileAsync.hasValue) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    //TODO alle provider preloaden

    return const HomeScreen();
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }
}

//TODO das iwie einbauen
// StreamBuilder<AuthState>(
//         stream: supabase.auth.onAuthStateChange,
//         builder: (context, snapshot) {
//           final session = supabase.auth.currentSession;
//           if (session != null) {
//             return const HomeScreen();
//           } else {
//             return const LoginScreen();
//           }
//         },
//       ),
