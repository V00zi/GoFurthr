// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/components/textfeild.dart';
import 'package:dotted_line/dotted_line.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //Log in method
  void signUp() async {
    //loading halo
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //main logic

    try {
      //check if pasword matches
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        popup("Passwords don't match");
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'email-already-in-use') {
        popup("User already exists!");
      }
    }
  }

  void popup(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: primary,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary2,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Image(
                  image: AssetImage('lib/assets/root/GFlogo.png'),
                  width: 250,
                  height: 250,
                ),

                const SizedBox(height: 50),

                //main text
                const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),

                const SizedBox(height: 20),

                //divider
                const DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: 375,
                  lineThickness: 3.0,
                  dashLength: 4.0,
                  dashColor: primary,
                  dashRadius: 5.0,
                  dashGapLength: 4.0,
                  dashGapRadius: 0.0,
                ),

                const SizedBox(height: 50),

                //text feilds
                CustTF(
                  controller: emailController,
                  hint: "E-mail",
                  obscure: false,
                  preicon: const Icon(Icons.email),
                  suficon: const Icon(Icons.cancel_outlined),
                ),

                const SizedBox(height: 30),

                CustTF(
                  controller: passwordController,
                  hint: "Password",
                  obscure: true,
                  preicon: const Icon(Icons.password),
                  suficon: const Icon(Icons.cancel_outlined),
                ),

                const SizedBox(height: 30),

                CustTF(
                  controller: confirmPasswordController,
                  hint: "Confirm Password",
                  obscure: true,
                  preicon: const Icon(Icons.password),
                  suficon: const Icon(Icons.cancel_outlined),
                ),

                const SizedBox(height: 30),

                //button
                CustBT(
                  onTap: signUp,
                  message: "Sign up",
                  sendIcon: Icons.person_add,
                ),
                const SizedBox(height: 50),

                //sign in methods
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already an user?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Login now!",
                        style: TextStyle(
                          color: primary,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: primary,
                          decorationThickness: 2,
                        ),
                      ),
                    )
                  ],
                ),

                //end of container
              ],
            ),
          ),
        ),
      ),
    );
  }
}
