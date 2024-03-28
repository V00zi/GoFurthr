// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/pages/vehicleDetails/vd_Page.dart';
import 'package:intl/intl.dart';
import 'package:gofurthr/components/toast.dart';

class EntryPage extends StatefulWidget {
  final String vehicleId;

  const EntryPage({
    super.key,
    required this.vehicleId,
  });

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _fuelController = TextEditingController();
  final _distanceController = TextEditingController();
  double fuel = 0;
  double distance = 0;
  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _fuelController.text = fuel.toString(); // Pre-fill fuel
    _distanceController.text = distance.toString(); // Pre-fill distance
  }

  Future<String> getCollectionName(String vehId) async {
    var query = _firestore
        .collection('userData')
        .doc(user.email)
        .collection('Vehicles')
        .doc(vehId)
        .collection('fuelData');
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

  void _writeFuelDataToFirestore(
      Map<String, dynamic> fuelData, String vehId) async {
    try {
      String entryName = await getCollectionName(vehId);
      final docRef = _firestore
          .collection('userData')
          .doc(user.email) // Use retrieved username
          .collection('Vehicles')
          .doc(vehId)
          .collection('fuelData')
          .doc(entryName); // Generate a unique document ID

      // Set the data in the document
      await docRef.set(fuelData);

      // Show success message (optional)
      popup("Data written!");
    }
    //
    on FirebaseException catch (e) {
      // Handle errors appropriately
      popup(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    final vehId = widget.vehicleId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fuel & Distance Entry'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _fuelController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Fuel (in L)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fuel amount.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Distance (in Km)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter distance.';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: $formattedDate'),
                  TextButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020, 1),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Change Date'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Get the entered values
                    final double enteredFuel =
                        double.parse(_fuelController.text);
                    final double enteredDistance =
                        double.parse(_distanceController.text);

                    final Map<String, dynamic> fuelData = {
                      'fuel': enteredFuel,
                      'distance': enteredDistance,
                      'date': Timestamp.fromDate(selectedDate),
                    };
                    _writeFuelDataToFirestore(fuelData, vehId);

                    print(
                      'Fuel: $enteredFuel L, Distance: $enteredDistance Km, Date: $formattedDate',
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetails(vehicleId: vehId),
                      ),
                    );
                    // You can also perform calculations, save data to a database, etc.
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
