import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/components/toast.dart';
import 'package:intl/intl.dart';

class LoadServiceData extends StatefulWidget {
  final String email;
  final String vehicleId;

  const LoadServiceData({
    super.key,
    required this.email,
    required this.vehicleId,
  });

  @override
  State<LoadServiceData> createState() => _LoadServiceDataState();
}

class _LoadServiceDataState extends State<LoadServiceData> {
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
        .collection('serviceData')
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
          .collection('serviceData')
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
  Widget buildServiceCard(DocumentSnapshot doc) {
    final serviceData = doc.data() as Map<String, dynamic>;

    DateTime date = serviceData["date"].toDate();
    String servicetype = serviceData["serviceType"].toString();
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    String entryId = doc.id; // Access document ID for deletion

    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 15.0,
        start: 15,
        end: 15,
        bottom: 8,
      ),
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          color: secondary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      'lib/assets/cardAssets/$servicetype.png',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 125,
                child: FittedBox(
                  //type data
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    servicetype,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 25),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: IconButton(
                      onPressed: () => deleteEntry(entryId),
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      iconSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            final serviceCards =
                querySnapshot.docs.map((doc) => buildServiceCard(doc)).toList();
            return Expanded(
              child: ListView(
                children: serviceCards,
              ),
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
