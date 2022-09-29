import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/pages/verifer_login.dart';
import 'package:zbgaming/widgets/favorite_organizer.dart';

class VerifierHomePage extends StatefulWidget {
  const VerifierHomePage({Key? key}) : super(key: key);

  @override
  State<VerifierHomePage> createState() => _VerifierHomePageState();
}

class _VerifierHomePageState extends State<VerifierHomePage> {
  // VARIABLES
  String? username;
  int index = 0;
  bool isLoading = false;

  // FUNCTIONS

  // singout and fetch data combined function
  signoutAndFetchData() async {
    isLoading = true;
    if (mounted) setState(() {});

    // fetchData
    await FirebaseFirestore.instance
        .collection("verifier")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => username = value['username'])
        .catchError((onError) async {
      Fluttertoast.showToast(msg: "Something went wrong");
      await FirebaseAuth.instance.signOut();
    });

    // Signout Event Listener
    FirebaseAuth.instance.authStateChanges().listen((User? event) {
      if (event?.uid == null) {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VerifierSignIn()));
        }
      }
    });
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    signoutAndFetchData();
  }

  @override
  Widget build(BuildContext context) {
    // BOTTOM NAV BAR WIDGETS
    BottomNavigationBarItem home = BottomNavigationBarItem(
        icon: Icon(index == 0 ? Icons.home : Icons.home_outlined), label: "Home", backgroundColor: Colors.blue);
    BottomNavigationBarItem verifyKYC = BottomNavigationBarItem(
        icon: Icon(index == 1 ? Icons.badge : Icons.badge_outlined),
        label: "Verify KYC",
        backgroundColor: Colors.green);
    BottomNavigationBarItem reports = BottomNavigationBarItem(
        icon: Icon(index == 2 ? Icons.report : Icons.report_outlined), label: "Reports", backgroundColor: Colors.red);

    return Scaffold(
        // BODY
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(text: "Welcome, "),
                                TextSpan(
                                  text: username,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                              style: const TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                          },
                          child: const Text("signout"),
                        )
                      ],
                    ),
                  ]),
          ),
        ),

        // BOTTOM NAV BAR
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[home, verifyKYC, reports],
          type: BottomNavigationBarType.shifting,
          currentIndex: index,
          onTap: (value) {
            index = value;
            setState(() {});
          },
        ));
  }
}
