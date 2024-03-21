import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gofurthr/components/globals.dart';

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
      stream: FirebaseFirestore.instance.collection('vehicleData').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const CircularProgressIndicator(); // or any other loading indicator
        }

        final vehicleIds = snapshot.data!.docs.map((doc) => doc.id).toList();

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedVehId,
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.black,
                  menuMaxHeight: 400,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 18,
                  ),
                  hint: Text(_selectedVehId ?? 'Select Vehicle',
                      style: const TextStyle(color: Colors.white)),
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
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedVehId !=
                null) // Display the second dropdown if a vehicle is selected
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vehicleData')
                    .doc(_selectedVehId)
                    .collection('Brands')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const CircularProgressIndicator(); // or any other loading indicator
                  }

                  final brandIds =
                      snapshot.data!.docs.map((doc) => doc.id).toList();

                  return Container(
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: DropdownButtonFormField<String>(
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.black,
                        menuMaxHeight: 400,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Coolvetica',
                          fontSize: 18,
                        ),
                        value: _selectedBrandId,
                        hint: Text(_selectedBrandId ?? 'Select Brand',
                            style: const TextStyle(color: Colors.white)),
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
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            if (_selectedBrandId !=
                null) // Display the third dropdown if a brand is selected
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vehicleData')
                    .doc(_selectedVehId)
                    .collection('Brands')
                    .doc(_selectedBrandId)
                    .collection('Models')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const CircularProgressIndicator(); // or any other loading indicator
                  }

                  final modelIds =
                      snapshot.data!.docs.map((doc) => doc.id).toList();

                  return Container(
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: DropdownButtonFormField<String>(
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.black,
                        menuMaxHeight: 400,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Coolvetica',
                          fontSize: 18,
                        ),
                        value: _selectedModelId,
                        hint: Text(_selectedModelId ?? 'Select Model',
                            style: const TextStyle(color: Colors.white)),
                        items: modelIds
                            .map((id) => DropdownMenuItem(
                                  value: id,
                                  child: Text(id),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _selectedModelId = value;
                        }),
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
