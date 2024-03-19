import 'package:flutter/material.dart';
import 'package:gofurthr/components/appbar.dart';
import 'package:gofurthr/pages/landing_page.dart';
import 'package:gofurthr/components/dropdown.dart';

class AddVeh extends StatelessWidget {
  const AddVeh({super.key});

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
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //title
                const Text(
                  "Add a new vehicle!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),

                //dropdown
                const DropMenu(),
                //back button needs to be changed
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LandingPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_circle_left,
                      size: 50,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
