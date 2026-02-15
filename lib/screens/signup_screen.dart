import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voc_trainer/screens/login_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "email"),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "password"),
          ),
          MaterialButton(
            onPressed: () async {
              final sm = ScaffoldMessenger.of(context);
              try {
                final authResponse = await supabase.auth.signUp(password: passwordController.text, email: emailController.text);
                if (authResponse.user != null) {
                  sm.showSnackBar(SnackBar(content: Text("Signed Up: ${authResponse.user!.email!}"))); //success
                  //return null;
                } else {
                  sm.showSnackBar(SnackBar(content: Text("An unknown Error occured")));
                } //success
              } on AuthException catch (e) {
                sm.showSnackBar(SnackBar(content: Text(e.message)));
              } catch (e) {
                sm.showSnackBar(SnackBar(content: Text("Error:$e")));
              }
            },
            child: Text("Signup"),
          ),
          GestureDetector(
            child: Text("switch to login"),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
