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
        imageId, fit: BoxFit.fill,
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
        child: Stack(
          //main coloumn
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            //top container delete and type icon
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //vehicle image
                Container(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
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
              ],
            ),

            //bottom container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(1),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0)
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // height: 40,
                        // width: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Image(
                              image: AssetImage(
                                  'lib/assets/cardAssets/$vehicleType.png'),
                              width: 45, // Adjusted for better scaling
                              height: 45, // Adjusted for better scaling
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      ),
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
                ),
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
                Column(
                  children: [
                    CarouselSlider(
                      items: vehicleCards,
                      carouselController: CarouselController(),
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 0.8,
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
