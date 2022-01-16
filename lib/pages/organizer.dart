// THIS IS FOR TESTING PURPOSE ONLY! DONT ADD IT TO PRODUCTION ENVIRONMENT

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/organizermodel.dart';

import 'package:zbgaming/pages/add_matches.dart';
import 'package:zbgaming/pages/organizer_login.dart';

class Organizer extends StatefulWidget {
  const Organizer({Key? key}) : super(key: key);

  @override
  State<Organizer> createState() => _OrganizerState();
}

class _OrganizerState extends State<Organizer> {
  // streams to subscribe
  Stream<QuerySnapshot> csgoStream = FirebaseFirestore.instance
      .collection("csgo")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  Stream<QuerySnapshot> valoStream = FirebaseFirestore.instance
      .collection("valo")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  Stream<QuerySnapshot> pubgStream = FirebaseFirestore.instance
      .collection("pubg")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  Stream<QuerySnapshot> freefireStream = FirebaseFirestore.instance
      .collection("freefire")
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  void initState() {
    super.initState();

    // check for authentication
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event?.uid == null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const OrganizerLogin()), (route) => false);
        }
      } else if (event?.uid != null) {
        if (mounted) {
          var data = await FirebaseFirestore.instance
              .collection("organizer")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
          context.read<OrganizerModel>().setuid(FirebaseAuth.instance.currentUser!.uid);
          context.read<OrganizerModel>().setusername(data["username"]);
          context.read<OrganizerModel>().setemail(data["email"]);
          context.read<OrganizerModel>().setimageurl(data["imageurl"]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // drawer
    Drawer organizerDrawer = Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                // zbunker element straight
                Container(
                    color: Colors.white,
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset("assets/images/zbunker-app-banner.png", fit: BoxFit.fitWidth)),
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          !(context.watch<OrganizerModel>().imageurl == null)
                              ? Stack(
                                  children: [
                                    CircleAvatar(backgroundColor: Colors.cyan[700], radius: 45),
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.cyan[700],
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                        foregroundImage: NetworkImage(context.watch<OrganizerModel>().imageurl!),
                                        radius: 40,
                                      ),
                                    )
                                  ],
                                )
                              : CircleAvatar(
                                  child: const FittedBox(
                                    fit: BoxFit.cover,
                                    child: Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                  backgroundColor: Colors.cyan[700],
                                  radius: 45),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              context.watch<OrganizerModel>().username == null
                                  ? "null"
                                  : context.watch<OrganizerModel>().username!,
                              style: const TextStyle(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]),
                  ),
                )
              ],
            )),
        ListTile(
          onTap: () {}, // leads to registered matches
          leading: const Icon(Icons.flag, color: Colors.black),
          trailing: const Icon(Icons.arrow_right, color: Colors.black),
          title: const Text(
            "Registered Matches",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {}, // leads to favorites
          leading: const Icon(Icons.star, color: Colors.black),
          trailing: const Icon(Icons.arrow_right, color: Colors.black),
          title: const Text(
            "Favorites",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {}, // leads to match history
          leading: const Icon(Icons.history, color: Colors.black),
          trailing: const Icon(Icons.arrow_right, color: Colors.black),
          title: const Text(
            "History",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {}, // leads to my account
          leading: const Icon(Icons.account_circle, color: Colors.black),
          trailing: const Icon(Icons.arrow_right, color: Colors.black),
          title: const Text(
            "My Account",
            style: TextStyle(color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {}, // leads to Settings
          leading: const Icon(Icons.settings, color: Colors.black),
          trailing: const Icon(Icons.arrow_right, color: Colors.black),
          title: const Text(
            "Settings",
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              // sign out user
              onPressed: () async {
                context.read<OrganizerModel>().signout();
                await FirebaseAuth.instance.signOut();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                  overlayColor: MaterialStateProperty.all(Colors.red[100]),
                  side: MaterialStateProperty.all(const BorderSide(color: Colors.red, width: 2))),
            )),
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: const Placeholder(), // zbgaming (copyrighted thing)
          height: 100,
        )
      ],
    ));

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const FittedBox(child: Text("Your Upcoming Matches")),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.headset_mic),
              // navigate to customer care
              onPressed: () {},
            )
          ],
        ),

        // body here
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
          stream: csgoStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("error loading data");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot e) => Card(
                          child: ListTile(

                              // csgo match
                              leading: const Text("csgo"),
                              title: Text(e["name"]),
                              subtitle: Text(e["date"].toDate().toString().substring(0, 11)),
                              trailing: ElevatedButton(
                                // write code for starting the match
                                child: const Text("start"),
                                onPressed: () {},
                              )),
                        ))
                    .toList());
          },
        )),

        // floating action button
        floatingActionButton: FloatingActionButton(
          // add matches page
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMatches(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        drawer: organizerDrawer,
      ),
    );
  }
}
