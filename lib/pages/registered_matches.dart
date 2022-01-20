import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/Date_to_string.dart';

class RegisteredMatches extends StatelessWidget {
  RegisteredMatches({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // widget to show when user is not signed in
  final Widget notSignedIn = const Text("Not Signed In");

  @override
  Widget build(BuildContext context) {
    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Your Registered Matches"), elevation: 0, centerTitle: true),
        body: _auth.currentUser?.uid == null ? notSignedIn : const BuildTiles(),
      ),
    );
  }
}

class BuildTiles extends StatefulWidget {
  const BuildTiles({Key? key}) : super(key: key);

  @override
  _BuildTilesState createState() => _BuildTilesState();
}

class _BuildTilesState extends State<BuildTiles> {
  bool isLoading = false;

  // stores the document snapshots
  List<QueryDocumentSnapshot> data = [];

  DateToString dateObject = DateToString();

  // retreives data
  void retreiveData() async {
    isLoading = true;
    setState(() {});
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("registered")
        .orderBy("date")
        .get()
        .then((value) {
      data = value.docs;
    });

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    retreiveData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => ListTile(
                  leading: Text(data[index]["matchType"]),
                  title: Text(data[index]["name"]),
                  subtitle: Text(dateObject.dateToString(data[index]["date"].toDate())),
                ));
  }
}
