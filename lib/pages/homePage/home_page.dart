import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/pages/homePage/landing_page.dart';
import 'package:gofurthr/pages/addVehicle/av_page.dart';
import 'dart:async';
import 'package:gofurthr/components/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gofurthr/pages/auth/auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ... other code

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const LandingPage(),
    const AddVeh(),
  ];

  final user = FirebaseAuth.instance.currentUser!;
  late StreamSubscription<User?> authStateChangesSubscription;

  @override
  void initState() {
    super.initState();
    authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // User is not signed in, navigate to login page
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AuthPage()));
      }
      setState(() {}); // Update UI to reflect user state
    });
  }

  @override
  void dispose() {
    authStateChangesSubscription.cancel(); // Clean up listener
    super.dispose();
  }

  //log out
  void logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 10,
            end: 5,
          ),
          child: SafeArea(
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
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: secondary2,
        height: 60,
        color: primary,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          Icon(
            Icons.home,
            size: 30,
          ),
          Icon(
            Icons.motorcycle_rounded,
            size: 30,
          ),
          Icon(
            Icons.settings,
            size: 30,
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
