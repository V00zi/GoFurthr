import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class SquareBT extends StatelessWidget {
  final String address;

  const SquareBT({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        address,
        height: 40,
      ),
    );
  }
}
