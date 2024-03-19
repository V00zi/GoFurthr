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
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 50,
            start: 10,
            end: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.person, size: 30, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "${user.email}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              IconButton(
                // Logout button on the right
                onPressed: logOut,
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                //welcome text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                //vehicle div
              ],
            ),
          ),
        ),
      ),
    );
  }
}
