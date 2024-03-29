import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/pages/homePage/home_page.dart';
import 'package:gofurthr/pages/vehicleDetails/add_new_fuel.dart';
import 'package:gofurthr/pages/vehicleDetails/load_fuel_data.dart';

class VehicleDetails extends StatefulWidget {
  final String vehicleId;
  const VehicleDetails({
    super.key,
    required this.vehicleId,
  });

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  late Future<DocumentSnapshot<Map<String, dynamic>>?> futureQuerySnapshot;

  @override
  void initState() {
    super.initState();
    futureQuerySnapshot = loadDetails();
    // Call to fetch data on initialization
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> loadDetails() async {
    final user = FirebaseAuth.instance.currentUser!;
    var query = FirebaseFirestore.instance
        .collection('userData')
        .doc(user.email)
        .collection('Vehicles')
        .doc(widget.vehicleId);
    return await query.get();
  }

  @override
  Widget build(BuildContext context) {
    final vehId = widget.vehicleId;
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: secondary2,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        centerTitle: true,
        backgroundColor: secondary2,
        flexibleSpace: Padding(
          padding: const EdgeInsetsDirectional.only(),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primary,
                  primary.withOpacity(0.5),
                  primary.withOpacity(0.4),
                  primary.withOpacity(0),
                  secondary2.withOpacity(0),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "VEHICLE DETAILS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 5,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_circle_left,
                        size: 30,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                  future: futureQuerySnapshot,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docData = snapshot.data!;

                    final brand = docData['Brand'];
                    final model = docData['Model'];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Brand: $brand",
                        ),
                        Text(
                          "Model: $model",
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primary, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Fuel Entries",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.gas_meter,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EntryPage(vehicleId: vehId),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //actual entries
                    const SizedBox(height: 20),
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: primary, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: LoadFuelData(
                                  email: user.email.toString(),
                                  vehicleId: vehId))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
