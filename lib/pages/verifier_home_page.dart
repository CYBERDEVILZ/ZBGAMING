import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/pages/verifer_login.dart';
import 'package:zbgaming/pages/verifier_kyc_verification.dart';

class VerifierHomePage extends StatefulWidget {
  const VerifierHomePage({Key? key}) : super(key: key);

  @override
  State<VerifierHomePage> createState() => _VerifierHomePageState();
}

class _VerifierHomePageState extends State<VerifierHomePage> {
  // VARIABLES
  String? username;
  int index = 0;
  int? kycNumber;
  int? reportNumber, specialMatchNumber, issueNumber;
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
        .then((value) {
      username = value['username'];
      isLoading = false;
      if (mounted) setState(() {});
    }).catchError((onError) async {
      Fluttertoast.showToast(msg: "Something went wrong");
      await FirebaseAuth.instance.signOut();
      isLoading = false;
      if (mounted) setState(() {});
    });

    // Signout Event Listener
    FirebaseAuth.instance.authStateChanges().listen((User? event) {
      if (event?.uid == null) {
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VerifierSignIn()));
        }
      }
    });

    // STREAMS
    FirebaseFirestore.instance.collection("kycPending").snapshots().listen((event) {
      kycNumber = event.docs.length;
      if (mounted) setState(() {});
    });
    FirebaseFirestore.instance.collection("reports").snapshots().listen((event) {
      reportNumber = event.docs.length;
      if (mounted) setState(() {});
    });
    FirebaseFirestore.instance.collection("specialMatchRequests").snapshots().listen((event) {
      specialMatchNumber = event.docs.length;
      if (mounted) setState(() {});
    });
    FirebaseFirestore.instance.collection("issues").snapshots().listen((event) {
      issueNumber = event.docs.length;
      if (mounted) setState(() {});
    });
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
      icon: Icon(index == 2 ? Icons.report : Icons.report_outlined),
      label: "Reports",
      backgroundColor: Colors.red,
    );
    BottomNavigationBarItem specialMatches = BottomNavigationBarItem(
      icon: Icon(index == 3 ? Icons.star : Icons.star_border),
      label: "Special Matches",
      backgroundColor: Colors.teal,
    );
    BottomNavigationBarItem generalActions = BottomNavigationBarItem(
      icon: Icon(index == 4 ? Icons.chat_bubble : Icons.chat_bubble_outline),
      label: "Queries / Issues",
      backgroundColor: Colors.pink,
    );

    return Scaffold(
        // BODY
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : index == 0
                    ? Column(children: [
                        // Container for username and signout button
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // username
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

                              // signout button
                              ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                },
                                child: const Text("signout"),
                              )
                            ],
                          ),
                        ),

                        // Container for Action Tiles
                        Container(
                          margin: const EdgeInsets.all(20),
                          width: double.infinity,
                          child: GridView.count(
                            cacheExtent: 0.5,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            shrinkWrap: true,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  index = 1;
                                  setState(() {});
                                },
                                child: Tile(
                                  text: "Verify KYC",
                                  color: Colors.green[400]!,
                                  numberOfRequests: kycNumber,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    index = 2;
                                    setState(() {});
                                  },
                                  child: Tile(
                                    text: "Manage Reports",
                                    color: Colors.red[400]!,
                                    numberOfRequests: reportNumber,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    index = 3;
                                    setState(() {});
                                  },
                                  child: Tile(
                                    text: "Special Match Requests",
                                    color: Colors.teal[400]!,
                                    numberOfRequests: specialMatchNumber,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    index = 4;
                                    setState(() {});
                                  },
                                  child: Tile(
                                    text: "Issues",
                                    color: Colors.pink[400]!,
                                    numberOfRequests: issueNumber,
                                  )),
                            ],
                          ),
                        )
                      ])
                    : index == 1
                        ? const KYCverificationPageForVerifier()
                        : Text("sldkfjsldkfj"),
          ),
        ),

        // BOTTOM NAV BAR
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          items: <BottomNavigationBarItem>[home, verifyKYC, reports, specialMatches, generalActions],
          type: BottomNavigationBarType.shifting,
          currentIndex: index,
          onTap: (value) {
            index = value;
            setState(() {});
          },
        ));
  }
}

class Tile extends StatefulWidget {
  const Tile({Key? key, required this.text, required this.color, this.numberOfRequests}) : super(key: key);

  @override
  State<Tile> createState() => _TileState();
  final String text;
  final Color color;
  final int? numberOfRequests;
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            widget.numberOfRequests == null
                ? const SizedBox(
                    height: 17,
                    width: 17,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ))
                : Text(
                    "${widget.numberOfRequests}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )
          ],
        ),
      ),
      color: widget.color,
    );
  }
}
