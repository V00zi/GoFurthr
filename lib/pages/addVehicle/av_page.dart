import 'package:flutter/material.dart';
import 'package:gofurthr/components/appbar.dart';
import 'package:gofurthr/pages/addVehicle/vehicles_menu.dart';

class AddVeh extends StatefulWidget {
  const AddVeh({super.key});

  @override
  State<AddVeh> createState() => _AddVehState();
}

class _AddVehState extends State<AddVeh> {
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

                  //dropdown
                  SizedBox(height: 50),
                  SimpleDropDown(),

                  //
                  //request new

                  //
                  //
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
