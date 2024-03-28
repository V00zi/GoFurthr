import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FuelDataList extends StatefulWidget {
  final String username;
  final String vehicleId;

  const FuelDataList(
      {Key? key, required this.username, required this.vehicleId})
      : super(key: key);

  @override
  State<FuelDataList> createState() => _FuelDataListState();
}

class _FuelDataListState extends State<FuelDataList> {
  List<String> documentList = [];

  @override
  void initState() {
    super.initState();
    getFuelData();
  }

  Future<void> getFuelData() async {
    final firestore = FirebaseFirestore.instance;

    final fuelDataRef = firestore
        .collection('userData')
        .doc(widget.username)
        .collection('Vehicles')
        .doc(widget.vehicleId)
        .collection('fuelData');

    final snapshot = await fuelDataRef.get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        documentList = snapshot.docs.map((doc) => doc.id).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return documentList.isNotEmpty
        ? ListView.builder(
            itemCount: documentList.length,
            itemBuilder: (context, index) => Text(
              documentList[index],
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        : const Text(
            'No documents found in fuelData',
            style: TextStyle(color: Colors.white, fontSize: 20),
          );
  }
}
