import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voc_trainer/screens/signup_screen.dart';
import 'package:voc_trainer/screens/home_screen.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                final authResponse = await supabase.auth.signInWithPassword(password: passwordController.text, email: emailController.text);
                if (authResponse.user != null) {
                  sm.showSnackBar(SnackBar(content: Text("Logged In: ${authResponse.user!.email!}"))); //success
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                  //return null;
                } else {
                  sm.showSnackBar(SnackBar(content: Text("Invalid email or pasword")));
                } //success
              } on AuthException catch (e) {
                sm.showSnackBar(SnackBar(content: Text(e.message)));
              } catch (e) {
                sm.showSnackBar(SnackBar(content: Text("Error:$e")));
              }
            },
            child: Text("Login"),
          ),
          GestureDetector(
            child: Text("switch to signup"),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignupScreen()));
            },
          ),
        ],
      ),
    );
  }
}
