import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/pages/landing_page.dart';
import 'package:gofurthr/pages/auth/login_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //is user logged in
          if (snapshot.hasData) {
            return const LandingPage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
