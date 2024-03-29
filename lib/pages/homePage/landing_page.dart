import 'package:flutter/material.dart';
import 'package:gofurthr/components/divide.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/pages/homePage/load_vehicle_data.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 40),
            child: Column(
              children: [
                //vehicle list divider
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      custDiv(50, 2, primary),
                      const Text(
                        " YOUR VEHICLES! ",
                        style: TextStyle(
                          fontSize: 12,
                          color: primary,
                          letterSpacing: 5,
                        ),
                      ),
                      custDiv(250, 2, primary)
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                //vehicle div

                const SizedBox(
                  child: Center(
                    child: LoadVehicleData(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
