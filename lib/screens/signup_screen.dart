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
                        hiddenPassword = !hiddenPassword;
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
                        final authResponse = await supabase.auth.signUp(
                          password: passwordController.text,
                          email: emailController.text,
                        );
                        if (authResponse.user != null) {
                          sm.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Signed Up: ${authResponse.user!.email!}",
                              ),
                            ),
                          ); //success
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          );
                        } else {
                          sm.showSnackBar(
                            SnackBar(content: Text("An unknown Error occured")),
                          );
                        }
                      } on AuthException catch (e) {
                        sm.showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        sm.showSnackBar(SnackBar(content: Text("Error:$e")));
                      }
                    },
                    child: Text(
                      "Signup",
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
                      "Already have an account?",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      child: Text(
                        "Login here",
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
                          MaterialPageRoute(builder: (_) => LoginScreen()),
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
