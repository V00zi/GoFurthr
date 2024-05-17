import 'package:flutter/material.dart';
import 'package:gofurthr/components/divide.dart';
import 'package:gofurthr/pages/homePage/load_insights.dart';
import 'package:gofurthr/pages/homePage/load_vehicle_data.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final scrWidth = MediaQuery.of(context).size.width;
    //final scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //vehicle list divider
                const SizedBox(height: 20),
                custDiv(scrWidth," YOUR VEHICLES! "),

                //vehicle div
                const LoadVehicleData(),   

                const SizedBox(height: 20),
                custDiv(scrWidth, " INSIGHTS! "),

                const SizedBox(height: 20),
                const LoadInsights(),
                

              ],
            ),
          ),
        ),
      ),
    );
  }
}
