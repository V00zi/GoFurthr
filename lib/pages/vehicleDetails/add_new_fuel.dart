import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/pages/vehicleDetails/vd_page.dart';
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

  DateTime selectedDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

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

    return Scaffold(
      backgroundColor: secondary2,
      appBar: AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        actions: [
          const Text(
            'NEW ENTRY',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  TextFormField(
                    controller: _fuelController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Fuel (in L)',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primary,
                        ),
                      ),
                      hintText: "Enter fuel",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter fuel amount.';
                      }
                      return null;
                    },
                  ),

                  //second TF
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _distanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Distance (in Km)',
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primary,
                        ),
                      ),
                      hintText: "Enter distance",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter distance.';
                      }
                      return null;
                    },
                  ),

                  //data box
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: $formattedDate',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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
                        child: const Text(
                          'Change Date',
                          style: TextStyle(
                            color: primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //

                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                    ),
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
                          'avg': double.parse((enteredDistance / enteredFuel)
                              .toStringAsFixed(2)),
                        };
                        _writeFuelDataToFirestore(fuelData, vehId);

                        // You can also perform calculations, save data to a database, etc.
                      }
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(letterSpacing: 5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
