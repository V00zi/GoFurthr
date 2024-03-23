import 'package:carousel_slider/carousel_slider.dart';
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
  int currentIdx = 0;

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

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.email)
          .collection('Vehicles')
          .doc(vehicleId)
          .delete();

      // Reload the vehicles after deletion
      setState(() {
        futureQuerySnapshot = loadVehicles();
      });
    } catch (error) {
      popup(error.toString());
    }
  }

  // Function to build a single vehicle card with access to vehicle data
  Widget buildVehicleCard(DocumentSnapshot doc) {
    final vehicleData = doc.data() as Map<String, dynamic>;
    String vehicleType = vehicleData["Type"];
    String vehicleBrand = vehicleData["Brand"];
    String vehicleModel = vehicleData["Model"];
    String vehicleId = doc.id; // Access document ID for deletion

    return Padding(
      padding: const EdgeInsetsDirectional.all(15.0),
      child: Container(
        width: 500,
        height: 250,
        decoration: BoxDecoration(
          color: secondary.withAlpha(100),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image(
                    image: AssetImage('lib/assets/cardAssets/$vehicleType.png'),
                    width: 250, // Adjusted for better scaling
                    height: 250, // Adjusted for better scaling
                  ),
                ),
                const SizedBox(width: 170),
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
                      vehicleBrand,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      vehicleModel,
                      style: const TextStyle(
                        color: primary,
                        fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot?>(
      future: futureQuerySnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final querySnapshot = snapshot.data!;
          if (querySnapshot.docs.isNotEmpty) {
            List<Widget> vehicleCards = [];
            for (var doc in querySnapshot.docs) {
              vehicleCards.add(buildVehicleCard(doc));
            }

            return Column(
              children: [
                // ... other widgets in your column

                Column(
                  children: [
                    CarouselSlider(
                      items: vehicleCards,
                      carouselController: CarouselController(),
                      options: CarouselOptions(
                        height: 270, // Adjust carousel height as needed
                        viewportFraction: 0.8, // Adjust viewport size as needed
                        onPageChanged: (index, reason) =>
                            setState(() => currentIdx = index),
                      ),
                    ),
                    // Indicator Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(querySnapshot.docs.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: CircleAvatar(
                            backgroundColor: currentIdx == index
                                ? primary // Adjust active color
                                : Colors.grey, // Adjust inactive color
                            radius: 3.0,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 123.0),
              child: Text(
                "Whoops! no vehicles!",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            );
          }
        } else if (snapshot.hasError) {
          // Handle errors
          popup(snapshot.error.toString());
          return const Text("");
        } else {
          // While loading
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 123.0),
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
