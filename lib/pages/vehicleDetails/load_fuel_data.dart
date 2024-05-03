import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/components/toast.dart';
import 'package:intl/intl.dart';

class LoadFuelData extends StatefulWidget {
  final String email;
  final String vehicleId;

  const LoadFuelData({
    super.key,
    required this.email,
    required this.vehicleId,
  });

  @override
  State<LoadFuelData> createState() => _LoadFuelDataState();
}

class _LoadFuelDataState extends State<LoadFuelData> {
  late Future<QuerySnapshot?> futureQuerySnapshot; // Store future for data

  @override
  void initState() {
    super.initState();
    futureQuerySnapshot = loadEntries(); // Call to fetch data on initialization
  }

  Future<QuerySnapshot?> loadEntries() async {
    var query = FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .collection('Vehicles')
        .doc(widget.vehicleId)
        .collection('fuelData')
        .orderBy('date', descending: true);

    return await query.get();
  }

  Future<void> deleteEntry(String entryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(widget.email)
          .collection('Vehicles')
          .doc(widget.vehicleId)
          .collection('fuelData')
          .doc(entryId)
          .delete();

      // Reload the vehicles after deletion
      setState(() {
        futureQuerySnapshot = loadEntries();
      });
    } catch (error) {
      popup(error.toString());
    }
  }

  // Function to build a single vehicle card with access to vehicle data
  Widget buildFuelCard(DocumentSnapshot doc) {
    final fuelData = doc.data() as Map<String, dynamic>;
    double distance = fuelData["distance"];
    double fuel = fuelData["fuel"];
    DateTime date = fuelData["date"].toDate();
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    String entryId = doc.id; // Access document ID for deletion

    double avgData = distance / fuel;
    String avg = avgData.toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 15.0,
        start: 15,
        end: 15,
        bottom: 8,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: primary2,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Image(
                                  image: AssetImage(
                                      "lib/assets/cardAssets/fuel.png"),
                                ),
                              ),
                              Text(
                                "   $fuel L",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: primary2,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Image(
                                  image: AssetImage(
                                      "lib/assets/cardAssets/distance.png"),
                                ),
                              ),
                              Text(
                                "   $distance Km",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8),
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: primary2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              children: [
                                Text(
                                  avg.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "Avg. Km/L",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            bottom: 67,
            left: 30,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " Date: $formattedDate",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => deleteEntry(entryId),
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.red,
                  iconSize: 30,
                ),
              ],
            ),
          )
        ],
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
            final fuelCards =
                querySnapshot.docs.map((doc) => buildFuelCard(doc)).toList();
            return ListView(
              children: fuelCards,
            );
          } else {
            return const Expanded(
              child: Center(
                child: Text(
                  "Whoops! no entries!",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
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
