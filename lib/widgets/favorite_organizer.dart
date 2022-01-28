import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/widgets/not_signed_in.dart';

class FavoriteOrganizers extends StatelessWidget {
  const FavoriteOrganizers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser?.uid == null ? const NotSignedIn() : const FetchData();
  }
}

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  _FetchDataState createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  bool isLoading = false;

  List<QueryDocumentSnapshot> fav = [];

  fetchdata() async {
    isLoading = true;
    setState(() {});
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("FavOrganizers")
        .get()
        .then((value) {
      fav = value.docs;
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Error occurred!");
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator()) : BuildTiles(fav: fav);
  }
}

class BuildTiles extends StatelessWidget {
  const BuildTiles({Key? key, required this.fav}) : super(key: key);

  final List<QueryDocumentSnapshot> fav;

  @override
  Widget build(BuildContext context) {
    return fav.isEmpty
        ? const Center(child: Text("No favorite organizers found"))
        : ListView.builder(
            itemBuilder: (context, index) => const ListTile(
                  leading: Text("logo here"),
                  title: Text("Title here"),
                  trailing: Text("Organizer page"),
                ));
  }
}
