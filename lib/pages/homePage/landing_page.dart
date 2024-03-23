import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
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
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 40),
            child: Column(
              children: [
                //vehicle list divider
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        lineLength: 50,
                        lineThickness: 2,
                        dashLength: 4.0,
                        dashColor: primary,
                        dashRadius: 5.0,
                        dashGapLength: 4.0,
                        dashGapRadius: 0.0,
                      ),
                      Text(
                        " YOUR VEHICLES! ",
                        style: TextStyle(
                          fontSize: 12,
                          color: primary,
                          letterSpacing: 5,
                        ),
                      ),
                      DottedLine(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        lineLength: 250,
                        lineThickness: 2,
                        dashLength: 4.0,
                        dashColor: primary,
                        dashRadius: 5.0,
                        dashGapLength: 4.0,
                        dashGapRadius: 0.0,
                      )
                    ],
                  ),
                ),

                SizedBox(height: 10),
                //vehicle div

                SizedBox(
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
