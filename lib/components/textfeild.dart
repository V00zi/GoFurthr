import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class CustTF extends StatelessWidget {
  final controller; //read input
  final String hint;
  final bool obscure;
  final Icon preicon;
  final Icon suficon;

  const CustTF({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.preicon,
    required this.suficon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: preicon,
          suffixIcon: IconButton(
            icon: suficon,
            onPressed: () => controller.clear(),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hint,
        ),
      ),
    );
  }
}
