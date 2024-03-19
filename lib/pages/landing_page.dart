import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gofurthr/pages/functionalities/create_veh.dart';
import 'package:gofurthr/components/appbar.dart';

class LandingPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  LandingPage({super.key});

  //log out
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  addNewVeh() {
    //add logic here
  }

  Widget buildCard() => Padding(
        padding: const EdgeInsetsDirectional.only(end: 15.0),
        child: Container(
          width: 200,
          height: 250,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 233, 233),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: custAB(),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildCard(),
                          buildCard(),
                          buildCard(),
                          buildCard(),
                        ],
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
