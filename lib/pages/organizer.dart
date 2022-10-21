// THIS IS FOR TESTING PURPOSE ONLY! DONT ADD IT TO PRODUCTION ENVIRONMENT

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/organizermodel.dart';

import 'package:zbgaming/pages/add_matches.dart';
import 'package:zbgaming/pages/organizer_account.dart';
import 'package:zbgaming/pages/organizer_login.dart';
import 'package:zbgaming/widgets/upcoming_matches.dart';

class Organizer extends StatefulWidget {
  const Organizer({Key? key}) : super(key: key);

  @override
  State<Organizer> createState() => _OrganizerState();
}

class _OrganizerState extends State<Organizer> {
  bool eligible = false;
  // streams to subscribe
  Stream<QuerySnapshot> csgoStream = FirebaseFirestore.instance
      .collection("csgo")
      .orderBy("date")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  Stream<QuerySnapshot> valoStream = FirebaseFirestore.instance
      .collection("valo")
      .orderBy("date")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  Stream<QuerySnapshot> pubgStream = FirebaseFirestore.instance
      .collection("pubg")
      .orderBy("date")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  Stream<QuerySnapshot> freefireStream = FirebaseFirestore.instance
      .collection("freefire")
      .orderBy("date")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  void initState() {
    super.initState();

    // check for authentication
    if (mounted) {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event?.uid == null) {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => const OrganizerLogin()), (route) => false);
          }
        } else if (mounted && event?.uid != null) {
          if (Provider.of<OrganizerModel>(context, listen: false).uid == null) {
            await Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => const OrganizerLogin()), (route) => false);
          }
          if (Provider.of<OrganizerModel>(context, listen: false).uid != null) {
            try {
              var data = await FirebaseFirestore.instance
                  .collection("organizer")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get();
              try {
                eligible = data["amountGiven"] <= 10000 ? true : false;
              } catch (e) {
                eligible = false;
              }
              context.read<OrganizerModel>().setuid(FirebaseAuth.instance.currentUser!.uid);
              context.read<OrganizerModel>().setusername(data["username"]);
              context.read<OrganizerModel>().setemail(data["email"]);
              context.read<OrganizerModel>().setimageurl(data["imageurl"]);
              try {
                context.read<OrganizerModel>().setbannerurl(data["bannerurl"]);
              } catch (e) {
                context.read<OrganizerModel>().setbannerurl(null);
              }
            } catch (e) {
              await FirebaseAuth.instance.signOut();
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const FittedBox(child: Text("Your Upcoming Matches")),
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle),
                // navigate to customer care
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrganizerAccount()));
                },
              )
            ],
          ),

          // upcoming matches
          body: ListView(padding: const EdgeInsets.all(10), children: [
            // CSGO
            Align(
                child: Container(
              child: const Text(
                "CS:GO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: const EdgeInsets.only(top: 5),
            )),

            // stream builder
            StreamBuilder<QuerySnapshot>(
              stream: csgoStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("An error occurred");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 30, child: FittedBox(child: CircularProgressIndicator()));
                }
                return UpcomingMatch(matchType: "csgo", snapshot: snapshot);
              },
            ),

            // FREE FIRE
            Align(
                child: Container(
              child: const Text(
                "Garena Free Fire",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: const EdgeInsets.only(top: 5),
            )),
            StreamBuilder<QuerySnapshot>(
              stream: freefireStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("An error occurred");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 30, child: FittedBox(child: CircularProgressIndicator()));
                }
                return UpcomingMatch(matchType: "freefire", snapshot: snapshot);
              },
            ),

            // PUBG
            Align(
                child: Container(
              child: const Text(
                "Battlegrounds Mobile India",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: const EdgeInsets.only(top: 5),
            )),
            StreamBuilder<QuerySnapshot>(
              stream: pubgStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("An error occurred");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 30, child: FittedBox(child: CircularProgressIndicator()));
                }
                return UpcomingMatch(matchType: "pubg", snapshot: snapshot);
              },
            ),

            // VALO
            Align(
                child: Container(
              child: const Text(
                "Valorant",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: const EdgeInsets.only(top: 5),
            )),

            // stream builder
            StreamBuilder<QuerySnapshot>(
              stream: valoStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("An error occurred");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 30, child: FittedBox(child: CircularProgressIndicator()));
                }
                return UpcomingMatch(matchType: "valo", snapshot: snapshot);
              },
            ),
          ]),

          // floating action button
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            // add matches page
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMatches(
                      eligible: eligible,
                    ),
                  ));
            },
            child: const Icon(Icons.add),
          )),
    );
  }
}
