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
  bool hiddenPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/vectorelements-lBU7MhUv4LQ-unsplash.png",
                  width: double.maxFinite,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: hiddenPassword,
                  decoration: InputDecoration(
                    labelText: "password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hiddenPassword = !hiddenPassword;
                        });
                      },
                      icon: Icon(
                        hiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final sm = ScaffoldMessenger.of(context);
                      try {
                        final authResponse = await supabase.auth
                            .signInWithPassword(
                              password: passwordController.text,
                              email: emailController.text,
                            );
                        if (authResponse.user != null) {
                          sm.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Logged In: ${authResponse.user!.email!}",
                              ),
                            ),
                          ); //success
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomeScreen()),
                          );
                        } else {
                          sm.showSnackBar(
                            SnackBar(content: Text("Invalid email or pasword")),
                          );
                        } //success
                      } on AuthException catch (e) {
                        sm.showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        sm.showSnackBar(SnackBar(content: Text("Error:$e")));
                      }
                    },
                    child: Text(
                      "Login",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Do not have an account yet?",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      child: Text(
                        "Signup here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => SignupScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
