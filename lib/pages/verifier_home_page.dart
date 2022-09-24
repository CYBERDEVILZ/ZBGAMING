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
      appBar: AppBar(
        title: const Text('Verifier Home Page, no need for an appbar, we will remove this for aesthetics'),
      ),
      body: Column(children: [
        Text("${FirebaseAuth.instance.currentUser?.email}"),
        ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text("signout"))
      ]),
    );
  }
}
