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
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset("assets/vectorelements-lBU7MhUv4LQ-unsplash.png", width: double.maxFinite, height: 400, fit: BoxFit.cover),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "email", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility)),
              ),
            ),
            SizedBox(height: 20),
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
      ),
    );
  }
}
