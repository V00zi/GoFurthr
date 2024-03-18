import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //log out
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary2,
      appBar: AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          const Icon(
            Icons.person_2_rounded,
            color: Colors.white,
          ),
          IconButton(
            onPressed: logOut,
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome back ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
