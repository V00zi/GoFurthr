import 'package:flutter/material.dart';
import 'package:gofurthr/components/appbar.dart';
import 'package:gofurthr/components/dropdown.dart';

class AddVeh extends StatelessWidget {
  const AddVeh({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: custAB('HOME PAGE', context),
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: const SimpleDropDown(),
                ),
                //back button needs to be changed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
