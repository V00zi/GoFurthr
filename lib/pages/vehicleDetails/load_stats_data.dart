// ignore_for_file: sized_box_for_whitespace

import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:intl/intl.dart';

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
  int averageSug = 0;
  int avgDays = 0;
  double actualMonths = 0;
  int suggestedMonths = 0;
  String vehicleName = "";
  List<double> avgData = [];
  List<double> distData = [];
  List<double> fuelData = [];
  List<String> fuelDateData = [];
  List<String> serviceDateData = [];
  String formattedNewDate="NA";

  Future<void> getMetadata() async {
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .collection('Vehicles')
        .doc(widget.vehicleId);

    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        vehicleName = data["Brand"] + " " + data["Model"];
      }
    }

    DocumentReference documentRef2 = FirebaseFirestore.instance
        .collection('vehicleMetadata')
        .doc(vehicleName);

    DocumentSnapshot documentSnapshot2 = await documentRef2.get();

    if (documentSnapshot2.exists) {
      Map<String, dynamic>? data =
          documentSnapshot2.data() as Map<String, dynamic>?;

      if (data != null) {
        averageSug = data['avgSuggested'];
        suggestedMonths = data['serviceInterval'];
      }
    }

    setState(() {});
  }

  Future<void> getData() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .collection('Vehicles')
        .doc(widget.vehicleId)
        .collection('fuelData')
        .orderBy("date", descending: false);
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

        // Assuming your timestamp field is named "date"
        Timestamp timestamp = data["date"];

        // Convert timestamp to DateTime
        DateTime dateTime = timestamp.toDate();

        // Format DateTime as "dd/mm/yy" string
        String formattedDate =
            "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString().substring(2)}";

        // Add formatted date to the list
        fuelDateData.add(formattedDate);
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

    calcAvgDays(fuelDateData, false);
    calcNextFuel(fuelDateData, avgDays);

    //
    //

    final collectionRef2 = FirebaseFirestore.instance
        .collection('userData')
        .doc(widget.email)
        .collection('Vehicles')
        .doc(widget.vehicleId)
        .collection('serviceData')
        .orderBy("date", descending: false);
    final querySnapshot2 = await collectionRef2.get();
    final List<DocumentSnapshot> documents2 = querySnapshot2.docs;

    // You can now query or iterate over the documents list
    // for example:
    for (final doc in documents2) {
      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null && data['serviceType'] == "Complete") {
        // Assuming your timestamp field is named "date"
        Timestamp timestamp = data["date"];

        // Convert timestamp to DateTime
        DateTime dateTime = timestamp.toDate();

        // Format DateTime as "dd/mm/yy" string
        String formattedDate =
            "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString().substring(2)}";

        // Add formatted date to the list
        serviceDateData.add(formattedDate);
      }
    }

    calcAvgDays(serviceDateData, true);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
    getMetadata();
  }

  void calcAvgDays(List<String> inp, bool month) {
    int sum = 0;
    int len = inp.length;
    double avg = 0;

    for (int i = 0; i < len; i += 2) {
      final formatter = DateFormat("dd/MM/yyyy");
      DateTime firstDate, secondDate;

      try {
        firstDate = formatter.parse(inp[i]);
        secondDate = formatter.parse(inp[i + 1]);
      } catch (e) {
        continue; // Skip to the next pair if parsing fails
      }

      // Calculate the difference in days
      Duration difference = secondDate.difference(firstDate);
      int daysBetween = difference.inDays;
      sum += daysBetween;
    }
    avg = sum / len;

    if (month == true) {
      final conv = (sum.toInt() / 30.4167).toStringAsFixed(1);
      actualMonths = len == 1 ? 0 : double.parse(conv);
      calcNextService(inp);
    } else {
      avgDays = len == 1 ? 0 : avg.toInt();
    }
  }

  void calcNextFuel(List<String> inp,int daysToAdd) {
    int len = inp.length;
    DateTime recentDate, newDate;
    
    final formatter = DateFormat("dd/MM/yy");
    recentDate = formatter.parse(inp[len - 1]);
    newDate = recentDate.add(Duration(days: daysToAdd));
    formattedNewDate =  formatter.format(newDate);
    
    if(daysToAdd!=0){
      
    }
  }

  void calcNextService(List<String> inp) {
    int len = inp.length;
    DateTime recentDate, newDate;
    double daysToAdd = suggestedMonths * 30.4167;

    final formatter = DateFormat("dd/MM/yy");
    recentDate = formatter.parse(inp[len - 1]);
    newDate = recentDate.add(Duration(days: daysToAdd.toInt()));
    formattedNewDate =  formatter.format(newDate);

    if(len>0){
      
    }
  }

  //builder
  Widget addCard(Color color, String label, dynamic value, String unit) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 134,
              height: 94,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$value",
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      " $unit",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white.withAlpha(100),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget vehicleCondtionBlock(int avgSug, double avgAct) {
    Color retColor = avgSug > avgAct ? Colors.red : Colors.green;
    Icon retIcon = avgSug > avgAct
        ? Icon(
            Icons.arrow_downward,
            color: retColor.withOpacity(0.3),
            size: 30,
          )
        : Icon(
            Icons.arrow_upward,
            color: retColor.withOpacity(0.3),
            size: 30,
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      avgSug.toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Suggested Mileage",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'VS',
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        ),
        const VerticalDivider(),
        Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          avgAct.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            color: retColor,
                          ),
                        ),
                        retIcon,
                      ],
                    ),
                  ),
                ),
                const Text(
                  "Your Mileage",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget serviceConditionBlock(int monSug, double monAct,String serviceDate) {
    Color retColor = Colors.white;
    Icon retIcon= Icon(Icons.error_outline,color: retColor.withOpacity(0.3),size: 30);
    if(monAct>0) {
      retColor = monSug < monAct ? Colors.red : Colors.green;
      retIcon = monSug < monAct ?
        Icon(
          Icons.arrow_downward,
          color: retColor.withOpacity(0.3),
          size: 30,
        ) :
        Icon(
          Icons.arrow_upward,
          color: retColor.withOpacity(0.3),
          size: 30,
        )
      ;
    }
      

     

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 120,
          width: 175,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      monSug.toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Suggested Service Interval\n(months)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(),
        Container(
          height: 120,
          width: 150,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                     serviceDate,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Next Service Date\n(dd/mm/yy)",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(),
        Container(
          height: 120,
          width: 175,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 60,
                  width: 200,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          monAct.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            color: retColor,
                          ),
                        ),
                        retIcon,
                      ],
                    ),
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Your Service Interval\n(months)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.assessment,
              color: Colors.white,
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              "Vehicle Statistics",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ],
        ),

        //row1
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addCard(Colors.red, "Lowest Fuel\nEfficiency", lowestAvg, "KM/L"),
            const SizedBox(width: 20),
            addCard(
                Colors.white, "Avgrage Fuel\nEfficiency", averageAvg, "KM/L"),
            const SizedBox(width: 20),
            addCard(
                Colors.green, "Highest Fuel\nEfficiency", highestAvg, "KM/L"),
          ],
        ),

        //row2
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addCard(Colors.cyan, "Total Distance\ncovered",
                totalDistance.toInt(), "KM"),
            const SizedBox(width: 20),
            addCard(
                Colors.orange, "Avg Days between\nFueling", avgDays, "DAYS"),
            const SizedBox(width: 20),
            addCard(Colors.pink, "Total Fuel\nutilized", totalFuel, "L"),
          ],
        ),

        //vs manucaturer
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety,
              color: Colors.white,
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              "Vehicle Condition",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ],
        ),
        //health
        const SizedBox(height: 30),
        vehicleCondtionBlock(averageSug, averageAvg),
        const SizedBox(height: 10),
        serviceConditionBlock(suggestedMonths, actualMonths,formattedNewDate),
        
      ],
    );
  }
}
