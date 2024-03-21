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
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  //title
                  Text(
                    "Add a new vehicle!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),

                  SizedBox(height: 50),
                  //dropdown
                  SimpleDropDown(),
                  //back button needs to be changed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
