import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gofurthr/components/globals.dart';

final user = FirebaseAuth.instance.currentUser!;
void logOut() {
  FirebaseAuth.instance.signOut();
}

Widget custAB() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.person, size: 30, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                "${user.email}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const IconButton(
            // Logout button on the right
            onPressed: logOut,
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}

// to embedd appbar

// appBar: PreferredSize(
//         preferredSize: const Size(double.maxFinite, 50),
//         child: custAB(),
//       ),