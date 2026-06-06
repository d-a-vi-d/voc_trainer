import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
bool isLoggedIn = false;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hiddenPassword = true;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
      ),
      onPressed: () async {
        final sm = ScaffoldMessenger.of(context);
        try {
          final authResponse = await supabase.auth.signUp(
            password: passwordController.text,
            email: emailController.text,
          );
          if (authResponse.user != null) {
            sm.showSnackBar(
              SnackBar(content: Text("Signed Up: ${authResponse.user!.email!}")),
            ); //success
            //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
          } else {
            sm.showSnackBar(const SnackBar(content: Text("An unknown Error occured")));
          }
        } on AuthException catch (e) {
          sm.showSnackBar(SnackBar(content: Text(e.message)));
        } catch (e) {
          sm.showSnackBar(SnackBar(content: Text("Error:$e")));
        }
      },
      child: const Text(
        "Signup",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}
