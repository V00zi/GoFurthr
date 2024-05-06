import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class LoadStats extends StatefulWidget {
  final String email;
  final String vehicleId;

  const LoadStats({
    super.key,
    required this.email,
    required this.vehicleId,
  });

  @override
  State<LoadStats> createState() => _LoadStatsState();
}

class _LoadStatsState extends State<LoadStats> {
  double lowestAvg = double.infinity;
  double highestAvg = 0;
  double averageAvg = 0;
  double totalDistance = 0;
  double totalFuel = 0;
  List<double> avgData = [];
  List<double> distData = [];
  List<double> fuelData = [];

  Future<void> getData() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .collection('Vehicles')
        .doc(widget.vehicleId)
        .collection('fuelData');
    final querySnapshot = await collectionRef.get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;

    // You can now query or iterate over the documents list
    // for example:
    for (final doc in documents) {
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        avgData.add(data["avg"]);
        distData.add(data["distance"]);
        fuelData.add(data["fuel"]);
      }
    }

    lowestAvg = avgData.reduce(math.min);
    highestAvg = avgData.reduce(math.max);

    double sum = 0.0;
    for (final avg in avgData) {
      sum += avg;
    }
    averageAvg = sum / avgData.length;
    averageAvg = double.parse(averageAvg.toStringAsFixed(2));

    for (final dist in distData) {
      totalDistance += dist;
    }
    totalDistance = double.parse(totalDistance.toStringAsFixed(2));

    for (final fuel in fuelData) {
      totalFuel += fuel;
    }
    totalFuel = double.parse(totalFuel.toStringAsFixed(2));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  //builder
  Widget addCard(Color color, String label, double value) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "$value",
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addCard(Colors.red, "Lowest Fuel\nEfficiency", lowestAvg),
            const SizedBox(width: 20),
            addCard(Colors.white, "Avgrage Fuel\nEfficiency", averageAvg),
            const SizedBox(width: 20),
            addCard(Colors.green, "Highest Fuel\nEfficiency", highestAvg),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addCard(Colors.cyan, "Total Distance\ncovered", totalDistance),
            const SizedBox(width: 20),
            addCard(secondary, "Avg Days between\nFueling(WIP)", 0.0),
            const SizedBox(width: 20),
            addCard(Colors.pink, "Total Fuel\nutilized", totalFuel),
          ],
        ),
      ],
    );
  }
}
