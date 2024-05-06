// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class LoadGraph extends StatefulWidget {
  final String email;
  final String vehicleId;

  const LoadGraph({
    super.key,
    required this.email,
    required this.vehicleId,
  });

  final Color barBackgroundColor = primary2;
  final Color barColor = primary;

  @override
  State<StatefulWidget> createState() => LoadGraphState();
}

class LoadGraphState extends State<LoadGraph> {
  List<BarChartGroupData> barEntries = [];

  Future<void> getData() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .collection('Vehicles')
        .doc(widget.vehicleId)
        .collection('fuelData');
    final querySnapshot = await collectionRef.get();

    barEntries = querySnapshot.docs.map((doc) {
      final data = doc.data();
      final x = data['date'];
      final y = data['avg'];

      // Check for data type and handle if necessary (e.g., convert date)

      return makeGroupData(x.toDate(), y);
    }).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  BarChartGroupData makeGroupData(DateTime date, double y) {
    return BarChartGroupData(
      x: date.day.toInt(),
      barRods: [
        BarChartRodData(
          toY: y,
          color: widget.barColor,
          borderRadius: BorderRadius.circular(18),
          width: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.graphic_eq,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Fuel Average Distribution',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: barEntries.isNotEmpty
                  ? BarChart(makeBarData())
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: const Center(
                        child: Text(
                          "Whoops Graph unavailable!\nAdd more entries!",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData makeBarData() {
    final double highestY = barEntries.fold(0.0, (previousValue, element) {
      final currentY = element.barRods.first.toY;
      return previousValue > currentY ? previousValue : currentY;
    });

    final double maxY = highestY + 10; // Add 10 for buffer

    return BarChartData(
      maxY: maxY,
      barTouchData: BarTouchData(
        enabled: true,
      ),
      titlesData: const FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 38,
          ),
          axisNameWidget: Text(
            "Entries",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          axisNameSize: 30,
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: false,
          ),
          axisNameWidget: Text(
            "Average",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          axisNameSize: 25,
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: barEntries,
      gridData: const FlGridData(show: true),
    );
  }
}
