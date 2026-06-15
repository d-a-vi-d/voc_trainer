import 'package:flutter/material.dart';
import 'package:voc_trainer/screens/home_screen.dart';
import 'package:voc_trainer/utils/error_snackbar.dart';
import 'package:voc_trainer/utils/special_exception.dart';

import '../main.dart';

// enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    // required this.mode
  });
  // final AuthMode mode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hiddenPassword = true;
  bool isLoading = false;

  // bool get isLogin => widget.mode == AuthMode.login;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    //TODO validierung
    setState(() => isLoading = true);
    //TODO in den provider damit
    try {
      final response = isLogin
          ? await supabase.auth.signInWithPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            )
          : await supabase.auth.signUp(
              email: emailController.text.trim(),
              password: passwordController.text,
            );

      if (!mounted) return;

      if (response.user == null) {
        context.showError(SpecialException(errorMessage: "Unbekannter Fehler"));
        return;
      }
      //TODO direkt zum homescreen aber soll appshell machen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      if (!mounted) return;
      context.showError(e);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

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
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: hiddenPassword,
                  decoration: InputDecoration(
                    labelText: "Passwort",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => hiddenPassword = !hiddenPassword),
                      icon: Icon(hiddenPassword ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: isLoading ? null : _submit,

                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            isLogin ? "Login" : "Signup",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      isLogin ? "Do not have an account yet?" : "Already have an account?",
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => isLogin ? const SignupScreen() : const LoginScreen(),
                        //   ),
                        // );
                      },
                      child: Text(
                        isLogin ? "Signup here" : "Login here",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
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
