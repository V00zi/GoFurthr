import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class LoadInsights extends StatefulWidget {
  const LoadInsights({super.key});

  @override
  State<LoadInsights> createState() => _LoadInsightsState();
}

class _LoadInsightsState extends State<LoadInsights> {
  
  final user=FirebaseAuth.instance.currentUser!;
  int totalVehicleCount=0;
  int totalCars=0;
  int totalBikes=0;
  int totalScooters=0;  

 Future<void> getData() async {
    final collectionRef = FirebaseFirestore.instance
        .collection('userData')
        .doc(user.email)
        .collection('Vehicles');
    final querySnapshot = await collectionRef.get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    
    if(documents.isNotEmpty){
      totalVehicleCount=documents.length;
      for (final doc in documents) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        switch(data["Type"]){
          case "Car":
            totalCars++;
            break;
          case "Bike":
            totalBikes++;
            break;
          case "Scooter":
            totalScooters++;
            break;
        }
      }

    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

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
            SizedBox(
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

  Widget vehicleCounter(int totalCars,int totalBikes,int totalScooters){
    TextStyle ts1= const TextStyle(color: Colors.white,fontSize: 30);
    BoxDecoration boxstyle1=BoxDecoration(borderRadius: BorderRadius.circular(20),color: primary.withOpacity(0.9),);
    

    Widget makeBox(String gifName, int count){
      return Container(
        width: 100,
        height: 50,
        decoration: boxstyle1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
    

            Flexible(child: Image.asset("lib/assets/gifs/$gifName.gif")),
            const VerticalDivider(color: Colors.transparent),
            FittedBox(
              fit: BoxFit.contain,
              child: Text("$count",style: ts1,)),
            
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makeBox("car", totalCars),
            const SizedBox(width: 10),
            makeBox("bike", totalBikes),
            const SizedBox(width: 10),
            makeBox("scooter", totalScooters),
          ],
        ),        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrWidth=MediaQuery.of(context).size.width;

    return Container(
      height: 400,
      width: double.infinity,
      color: Color.fromARGB(45, 238, 114, 114),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            vehicleCounter(totalCars, totalBikes, totalScooters),
            const SizedBox(height: 20),
            Container(
              height: 250,
              width: scrWidth-70,
              color: Colors.blue,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(6, (index) {
                  return Container(
                    height: 50,
                    width: 50,
                    color: Colors.white,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}