import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class CustBT extends StatelessWidget {
  final Function()? onTap;

  const CustBT({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 150.0),
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(width: 10),
              Text(
                "LOG IN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
