import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gofurthr/pages/auth/auth_page.dart';
import 'package:gofurthr/pages/addVehicle/av_page.dart';
import 'package:gofurthr/pages/homePage/load_vehicle_data.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: AppBar(
          backgroundColor: primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                //welcome text
                const Row(
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

                const SizedBox(height: 20),
                //vehicle div

                Stack(
                  children: [
                    //first child
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: primary, width: 2),
                      ),
                      child: const Center(
                        child: LoadVehicleData(),
                      ),
                    ),

                    //Second child
                    Positioned(
                        // Positions the button at the bottom right corner
                        bottom: 0.0,
                        right: 0.0,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddVeh(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: primary,
                              size: 70,
                            ))),
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
