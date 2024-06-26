// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/pages/homePage/home_page.dart';

class AddVehBT extends StatefulWidget {
  bool isEnabled;
  String type;
  String brand;
  String model;
  String fuel;

  AddVehBT({
    super.key,
    required this.isEnabled,
    required this.type,
    required this.brand,
    required this.model,
    required this.fuel,
  });

  @override
  State<AddVehBT> createState() => _AddVehBTState();
}

class _AddVehBTState extends State<AddVehBT> {
  final user = FirebaseAuth.instance.currentUser!;
  final collectionRef = FirebaseFirestore.instance.collection('userData');

  void writeData() async {
    collectionRef.doc(user.email).set({});

    // Call getCollectionName asynchronously to obtain the subcollection name
    String subcollectionRef = await getCollectionName();

    // Write data to the document with the generated subcollection name
    await collectionRef
        .doc(user.email)
        .collection('Vehicles')
        .doc(subcollectionRef)
        .set({
      'Type': widget.type,
      'Brand': widget.brand,
      'Model': widget.model,
      'FuelType': widget.fuel,
    });
    //code to go back to homepage
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<String> getCollectionName() async {
    var query = collectionRef.doc(user.email).collection('Vehicles');
    var querySnapshot = await query.get();
    int number;

    if (querySnapshot.docs.isNotEmpty) {
      number = querySnapshot.docs.length;
    } else {
      number = 0;
    }

    String subcollectionRef = 'vehicle$number';
    return subcollectionRef;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        onPressed: widget.isEnabled
            ? () {
                writeData();
                setState(() {
                  widget.isEnabled = false;
                });
              }
            : null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey[900],
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ADD VEHICLE",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
