import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class CustBT extends StatelessWidget {
  final Function()? onTap;

  final String message;
  final IconData sendIcon;

  const CustBT({
    super.key,
    required this.onTap,
    required this.message,
    required this.sendIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 120.0),
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                sendIcon,
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(width: 10),
              Text(
                message,
                style: const TextStyle(
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
