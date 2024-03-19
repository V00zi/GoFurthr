import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DropMenu extends StatefulWidget {
  const DropMenu({super.key});

  @override
  State<DropMenu> createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {
//calling vehicle type
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(

        //calling the firestore
        stream: FirebaseFirestore.instance.collection('veh_type').snapshots(),

        //fetch veh
        builder: (context, snapshot) {
          List<DropdownMenuItem> vehItems = [];
          if (!snapshot.hasData) {
            const CircularProgressIndicator();
          } else {
            final vehType = snapshot.data?.docs.reversed.toList();
            for (var type in vehType!) {
              vehItems.add(
                DropdownMenuItem(
                  value: type.id,
                  child: Text(
                    type['output'],
                  ),
                ),
              );
            }
          }

          //mapping
          return SizedBox(
            height: 55,
            width: 300,
            child: DropdownButton(
              icon: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(10),
              hint: const Text(
                "Vehicle Type",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              items: vehItems,
              menuMaxHeight: 500,
              onChanged: (brandValue) {
                //write to firebase
              },
            ),
          );
        });
  }

  // //calling brands
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(

  //       //calling the firestore
  //       stream: FirebaseFirestore.instance.collection('brands').snapshots(),

  //       //fetch
  //       builder: (context, snapshot) {
  //         List<DropdownMenuItem> brandItems = [];
  //         if (!snapshot.hasData) {
  //           const CircularProgressIndicator();
  //         }
  //         //
  //         else {
  //           final brands = snapshot.data?.docs.reversed.toList();
  //           for (var brand in brands!) {
  //             brandItems.add(
  //               DropdownMenuItem(
  //                 value: brand.id,
  //                 child: Text(
  //                   brand['Brand'],
  //                 ),
  //               ),
  //             );
  //           }
  //         }

  //         //mapping
  //         return SizedBox(
  //           height: 55,
  //           width: 300,
  //           child: DropdownButton(
  //             icon: const SizedBox.shrink(),
  //             borderRadius: BorderRadius.circular(10),
  //             hint: const Text(
  //               "Brand",
  //               style: TextStyle(color: Colors.white, fontSize: 30),
  //             ),
  //             items: brandItems,
  //             menuMaxHeight: 500,
  //             onChanged: (brandValue) {
  //               //write to firebase
  //             },
  //           ),
  //         );
  //       });
  // }

  // //calling models
  // @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(

  //       //calling the firestore
  //       stream: FirebaseFirestore.instance.collection('brands').snapshots(),

  //       //fetch
  //       builder: (context, snapshot) {
  //         List<DropdownMenuItem> brandItems = [];
  //         if (!snapshot.hasData) {
  //           const CircularProgressIndicator();
  //         } else {
  //           final brands = snapshot.data?.docs.reversed.toList();
  //           for (var brand in brands!) {
  //             brandItems.add(
  //               DropdownMenuItem(
  //                 value: brand.id,
  //                 child: Text(
  //                   brand['Brand'],
  //                 ),
  //               ),
  //             );
  //           }
  //         }

  //         //mapping
  //         return SizedBox(
  //           height: 55,
  //           width: 300,
  //           child: DropdownButton(
  //             icon: const SizedBox.shrink(),
  //             borderRadius: BorderRadius.circular(10),
  //             hint: const Text(
  //               "Brand",
  //               style: TextStyle(color: Colors.white, fontSize: 30),
  //             ),
  //             items: brandItems,
  //             menuMaxHeight: 500,
  //             onChanged: (brandValue) {
  //               //write to firebase
  //             },
  //           ),
  //         );
  //       });
  // }
}
