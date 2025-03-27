import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_vertexai/firebase_vertexai.dart";
import "package:flutter/material.dart";
import "package:testing_pill_pal/auth/check_account.dart";
import "package:testing_pill_pal/auth/login_or_register.dart";
import "package:testing_pill_pal/pages/home_page.dart";

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userEmail = snapshot.data?.email;
              return CheckAccount(email: userEmail!);
            } else {
              return LoginOrRegister();
            }
          }),
    );
  }
}
