import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofurthr/components/button.dart';
import 'package:gofurthr/components/globals.dart';
import 'package:gofurthr/components/textfeild.dart';
import 'package:dotted_line/dotted_line.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //Log in method
  void logIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        wrongemail();
      } else if (e.code == 'wrong-password') {
        wrongpassword();
      }
    }
  }

  void wrongemail() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("No such Email exists"),
        );
      },
    );
  }

  void wrongpassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect password"),
        );
      },
    );
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
                  image: AssetImage('lib/assets/GFlogo.png'),
                  width: 250,
                  height: 250,
                ),

                const SizedBox(height: 50),

                //main text
                const Text(
                  "Log In",
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

                const SizedBox(height: 10),

                //forgot pass
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //button
                CustBT(
                  onTap: logIn,
                ),

                const SizedBox(height: 50),

                //sign in methods
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Need an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Create one!",
                      style: TextStyle(
                        color: primary,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        decorationColor: primary,
                        decorationThickness: 2,
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
