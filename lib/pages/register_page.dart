// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pill_pal/auth/auth_methods.dart';
import 'package:pill_pal/components/error_display.dart';
import 'package:pill_pal/components/my_button.dart';
import 'package:pill_pal/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController confirmpasswordcontroller = TextEditingController();

  void registerUser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      Navigator.pop(context);

      displayErrorMessage("Passwords do not match", context);
    } else {
      try {
        String res = await AuthMethods().signUpUser(
            email: emailcontroller.text, password: passwordcontroller.text);

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayErrorMessage(e.code, context);
      }
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
                        obscureText: false,
                        controller: emailcontroller),

                    const SizedBox(
                      height: 10,
                    ),

                    MyTextfield(
                        hintText: "Password",
                        obscureText: true,
                        controller: passwordcontroller),

                    const SizedBox(
                      height: 10,
                    ),

                    MyTextfield(
                        hintText: "Confirm Password",
                        obscureText: true,
                        controller: confirmpasswordcontroller),

                    const SizedBox(
                      height: 25,
                    ),

                    MyButton(onTap: registerUser, text: "Create account"),

                    const SizedBox(
                      height: 25,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            " Login Here",
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
