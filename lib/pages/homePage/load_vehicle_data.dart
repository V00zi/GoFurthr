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

  Future<Widget> getAssetImageByPattern(String brand, String model) async {
    String imageId = "lib/assets/Car/$brand $model 1.jpg";

    try {
      Image image = Image.asset(
        imageId,
        fit: BoxFit.fitWidth,
        width: 1000,
        // high number to accomodate stretch for square aspect ratios
      ); // Use BoxFit.fill to stretch and overflow
      return image;
    } catch (e) {
      return const Image(image: AssetImage("lib/assets/Car/placeholder.jpg"));
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          //main coloumn
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            //top container delete and type icon
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
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
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Image(
                              image: AssetImage(
                                  'lib/assets/cardAssets/$vehicleType.png'),
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
                    ],
                  ),
                ),

                //middle
                Container(
                  height: 140,
                  color: Colors.white,
                  child: ClipRect(
                    child: FutureBuilder<Widget>(
                      future:
                          getAssetImageByPattern(vehicleBrand, vehicleModel),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!; // Use the retrieved AssetImage
                        }
                        //
                        else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Handle errors
                        }
                        return const CircularProgressIndicator(); // Show loading indicator while waiting
                      },
                    ),
                  ),
                ),

                //bottom container
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
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
                    ],
                  ),
                ),
              ],
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
                Column(
                  children: [
                    CarouselSlider(
                      items: vehicleCards,
                      carouselController: CarouselController(),
                      options: CarouselOptions(
                        height: 290,
                        viewportFraction: 0.75,
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
