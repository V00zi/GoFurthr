import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

Widget custAB(String title, BuildContext context) {
  return AppBar(
    backgroundColor: primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    centerTitle: true,
    flexibleSpace: Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 50,
        start: 10,
        end: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 5,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_circle_left,
                size: 30,
                color: Colors.white,
              )),
        ],
      ),
    ),
    //back button
  );
}

// to embedd appbar

// appBar: PreferredSize(
//         preferredSize: const Size(double.maxFinite, 50),
//         child: custAB(),
//       ),