import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore dependency

class SimpleDropDown extends StatefulWidget {
  const SimpleDropDown({Key? key}) : super(key: key);

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState();
}

class _SimpleDropDownState extends State<SimpleDropDown> {
  String? _selectedVehId;
  String? _selectedBrandId;
  String? _selectedModelId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //first dropdown

      stream: FirebaseFirestore.instance.collection('vehicleData').snapshots(),
      builder: (context, snapshot) {
        final vehicleIds = snapshot.data!.docs.map((doc) => doc.id).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedVehId,
                hint: Text(_selectedVehId ?? 'Select Vehicle'),
                items: vehicleIds
                    .map((id) => DropdownMenuItem(
                          value: id,
                          child: Text(id),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _selectedVehId = value;
                  _selectedBrandId = null;
                  _selectedModelId = null;
                }),
              ),

              // Conditionally render the second dropdown
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vehicleData')
                    .doc(_selectedVehId)
                    .collection('Brands')
                    .snapshots(),
                builder: (context, snapshot) {
                  final brandIds =
                      snapshot.data!.docs.map((doc) => doc.id).toList();

                  return DropdownButtonFormField<String>(
                    value: _selectedBrandId,
                    hint: Text(_selectedBrandId ?? 'Select Brand'),
                    items: brandIds
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text(id),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedBrandId = value;
                      _selectedModelId = null;
                    }),
                  );
                },
              ),

              //third dropdown

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vehicleData')
                    .doc(_selectedVehId)
                    .collection('Brands')
                    .doc(_selectedBrandId)
                    .collection('Models')
                    .snapshots(),
                builder: (context, snapshot) {
                  final brandIds =
                      snapshot.data!.docs.map((doc) => doc.id).toList();

                  return DropdownButtonFormField<String>(
                    value: _selectedModelId,
                    hint: Text(_selectedModelId ?? 'Select Model'),
                    items: brandIds
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text(id),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedModelId = value;
                    }),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
