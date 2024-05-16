import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/pages/vehicleDetails/vd_page.dart';
import 'package:intl/intl.dart';
import 'package:gofurthr/components/toast.dart';

class ServiceEntryPage extends StatefulWidget {
  final String vehicleId;

  const ServiceEntryPage({
    super.key,
    required this.vehicleId,
  });

  @override
  State<ServiceEntryPage> createState() => _ServiceEntryPageState();
}

class _ServiceEntryPageState extends State<ServiceEntryPage> {
  bool serviceType = true; // Initial state for fuel entry

  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> getCollectionName(String vehId) async {
    var query = _firestore
        .collection('userData')
        .doc(user.email)
        .collection('Vehicles')
        .doc(vehId)
        .collection('serviceData');
    var querySnapshot = await query.get();
    int number;

    if (querySnapshot.docs.isNotEmpty) {
      number = querySnapshot.docs.length;
    } else {
      number = 0;
    }

    String subcollectionRef = 'entry$number';
    return subcollectionRef;
  }

  void writeServiceData(Map<String, dynamic> serviceData, String vehId) async {
    try {
      String entryName = await getCollectionName(vehId);
      final docRef = _firestore
          .collection('userData')
          .doc(user.email) // Use retrieved username
          .collection('Vehicles')
          .doc(vehId)
          .collection('serviceData')
          .doc(entryName); // Generate a unique document ID

      // Set the data in the document
      await docRef.set(serviceData);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => VehicleDetails(vehicleId: vehId)),
        );
      }
    } on FirebaseException catch (e) {
      // Handle errors appropriately
      popup(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final vehId = widget.vehicleId;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: secondary2,
      appBar: AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          const Text(
            'NEW SERVICE ENTRY',
            style:
                TextStyle(letterSpacing: 5, fontSize: 20, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => VehicleDetails(vehicleId: vehId)),
              );
            },
            icon: const Icon(Icons.arrow_circle_left),
            iconSize: 30,
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              // Service Type
              const SizedBox(height: 100),

              //service type
              const Text(
                "Choose the type of Service",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 75,
                  width: screenWidth - 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              serviceType = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: serviceType
                                ? primary
                                : secondary.withOpacity(0.3),
                          ),
                          child: const Text(
                            'Partial',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              serviceType = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !serviceType
                                ? primary
                                : secondary.withOpacity(0.3),
                          ),
                          child: const Text(
                            'Complete',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //date and submit
              const SizedBox(height: 50),
              const Text(
                "Choose the date of Service",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),

              // Date Picker
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text('Select Date: $formattedDate'),
                  ),

                  //submit
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Validate and write service data
                      writeServiceData(
                        {
                          'serviceType': serviceType ? 'Partial' : 'Complete',
                          'date': selectedDate,
                          // Add other service data fields here
                        },
                        widget.vehicleId,
                      );
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
