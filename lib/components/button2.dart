import 'package:flutter/material.dart';
import 'package:gofurthr/components/globals.dart';

class CustPF extends StatefulWidget {
  final TextEditingController controller; //read input
  final String hint;
  final bool obscure;
  final Icon initialIcon;

  const CustPF({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.initialIcon,
  });

  @override
  State<CustPF> createState() => _CustPFState();
}

class _CustPFState extends State<CustPF> {
  bool _hasFocus = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: TextField(
        onTap: () => setState(() => _hasFocus = true),
        controller: widget.controller,
        obscureText:
            _hasFocus ? widget.obscure : false, // Obscure only on focus
        decoration: InputDecoration(
          prefixIcon: _hasFocus
              ? (_isObscure
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.lock))
              : widget.initialIcon,
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
          hintText: widget.hint,
        ),
      ),
    );
  }
}
