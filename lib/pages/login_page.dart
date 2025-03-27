// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing_pill_pal/components/error_display.dart';
import 'package:testing_pill_pal/components/my_button.dart';
import 'package:testing_pill_pal/components/my_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  void login() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);

      if (context.mounted) {
        Navigator.pop(context);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', emailcontroller.text);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context);
      displayErrorMessage("Invalid username or password", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // const Color.fromARGB(47, 230, 236, 255),
                  const Color.fromARGB(44, 192, 203, 251),
                  Colors.grey.shade100, // End color
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    //logo
                    Image.asset(
                      'assets/login.png',
                      width: 300, // Adjust width
                      height: 300, // Adjust height
                      fit: BoxFit.cover, // Adjust how the image fits
                    ),
                    Text(
                      "P I L L  P A L",
                      style: GoogleFonts.quicksand(
                          fontSize: 28, fontWeight: FontWeight.w400),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    MyTextfield(
                        hintText: "Email",
                        isPassword: false,
                        controller: emailcontroller),

                    const SizedBox(
                      height: 10,
                    ),

                    MyTextfield(
                        hintText: "Password",
                        isPassword: true,
                        controller: passwordcontroller),

                    //       Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       "Forgot Password?",
                    //       style: TextStyle(
                    //         color: Theme.of(context).colorScheme.secondary,
                    //       ),
                    //     )
                    //   ],
                    // ),

                    const SizedBox(
                      height: 25,
                    ),

                    MyButton(onTap: login, text: "Login"),

                    const SizedBox(
                      height: 25,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Register Here",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
