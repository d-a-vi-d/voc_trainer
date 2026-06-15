import 'package:flutter/material.dart';
//import 'package:frag_mama_papa/utils/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

      //backgroundColor: AppColors.neutralLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
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
                    labelText: "email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: hiddenPassword,
                  decoration: InputDecoration(
                    labelText: "password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hiddenPassword = !hiddenPassword;
                        });
                      },
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final sm = ScaffoldMessenger.of(context);
                      try {
                        final authResponse = await supabase.auth.signInWithPassword(
                          password: passwordController.text,
                          email: emailController.text,
                        );
                        if (authResponse.user != null) {
                          sm.showSnackBar(
                            SnackBar(content: Text("Logged In: ${authResponse.user!.email!}")),
                          ); //success
                          // Navigator.of(
                          //   context,
                          // ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                        } else {
                          sm.showSnackBar(
                            const SnackBar(content: Text("Invalid email or pasword")),
                          );
                        } //success
                      } on AuthException catch (e) {
                        sm.showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        sm.showSnackBar(SnackBar(content: Text("Error:$e")));
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
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
                    const Text("Do not have an account yet?", style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                    GestureDetector(
                      child: const Text(
                        "Signup here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          letterSpacing: -1,
                        ),
                      ),
                      onTap: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => SignupScreen()),
                        // );
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
