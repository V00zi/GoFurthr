import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/components/toast.dart';

class LoadVehicleData extends StatefulWidget {
  const LoadVehicleData({super.key});

  @override
  State<LoadVehicleData> createState() => _LoadVehicleDataState();
}

class _LoadVehicleDataState extends State<LoadVehicleData> {
  late Future<QuerySnapshot?> futureQuerySnapshot; // Store future for data

  @override
  void initState() {
    super.initState();
    futureQuerySnapshot =
        loadVehicles(); // Call to fetch data on initialization
  }

  Future<QuerySnapshot?> loadVehicles() async {
    final user = FirebaseAuth.instance.currentUser!;
    var query = FirebaseFirestore.instance
        .collection('userData')
        .doc(user.email)
        .collection('Vehicles');
    return await query.get();
  }

  //delete vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.email)
          .collection('Vehicles')
          .doc(vehicleId)
          .delete();
      popup(
          "Vehicle deleted successfully"); // Assuming popup is a function to show a success message
      // Reload the vehicles after deletion
      setState(() {
        futureQuerySnapshot = loadVehicles();
      });
    } catch (error) {
      popup("Failed to delete vehicle: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot?>(
      future: futureQuerySnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final querySnapshot = snapshot.data!;
          if (querySnapshot.docs.isNotEmpty) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Build cards for each vehicle
                  for (var doc in querySnapshot.docs)
                    buildVehicleCard(doc.id, doc.data()),
                ],
              ),
            );
          }
          //no vehicles with user
          else {
            return const Text(
              "Whoops! no vehicles!",
              style: TextStyle(color: Colors.white, fontSize: 25),
            );
          }
        }

        //
        else if (snapshot.hasError) {
          // Handle errors
          popup(snapshot.error.toString());
          return const Text("");
        }

        //
        else {
          // While loading
          return const Text("Loading...");
        }
      },
    );
  }

  // Function to build a single vehicle card
  Widget buildVehicleCard(String vehicleId, dynamic vehicleData) {
    String veichleBrand = vehicleData["Brand"];
    String veichleModel = vehicleData["Model"];

    //
    return Padding(
      padding: const EdgeInsetsDirectional.all(15.0),
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          color: secondary.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //delete button
                IconButton(
                  onPressed: () => deleteVehicle(vehicleId),
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      veichleBrand.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      veichleModel.toUpperCase(),
                      style: const TextStyle(
                        color: primary,
                        fontSize: 16,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
