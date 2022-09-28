import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/pages/verifer_login.dart';

class VerifierHomePage extends StatefulWidget {
  const VerifierHomePage({Key? key}) : super(key: key);

  @override
  State<VerifierHomePage> createState() => _VerifierHomePageState();
}

class _VerifierHomePageState extends State<VerifierHomePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: ((context) => const VerifierSignIn())), (route) => false);
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Text("Welcome, " + "${FirebaseAuth.instance.currentUser?.uid}"),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text("signout"))
        ]),
      ),
    );
  }
}
