import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/widgets/not_signed_in.dart';
import 'package:zbgaming/widgets/organizer_info.dart';

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
        .collection("favOrganizers")
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Organizers"),
        elevation: 0,
      ),
      body: fav.isEmpty
          ? const Center(child: Text("No favorite organizers found"))
          : ListView.builder(
              itemBuilder: (context, index) => Container(
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.blue))),
                  margin: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OrganizerTiles(ouid: fav[index]["ouid"])),
              itemCount: fav.length,
            ),
    );
  }
}

class OrganizerTiles extends StatefulWidget {
  const OrganizerTiles({Key? key, required this.ouid}) : super(key: key);
  final String ouid;

  @override
  _OrganizerTilesState createState() => _OrganizerTilesState();
}

class _OrganizerTilesState extends State<OrganizerTiles> {
  bool isLoading = true;
  String? imageurl;
  String? name;

  void fetchOrganizerData() async {
    await FirebaseFirestore.instance.collection("organizer").doc(widget.ouid).get().then((value) {
      try {
        imageurl = value["imageurl"];
      } catch (e) {
        imageurl = null;
      }

      try {
        name = value["username"];
      } catch (e) {
        name = null;
      }
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchOrganizerData();
  }

  @override
  Widget build(BuildContext context) {
    return imageurl != null
        ? ListTile(
            leading: CircleAvatar(
              maxRadius: 40,
              backgroundImage: NetworkImage(imageurl!),
            ),
            title: name != null ? Text(name!) : const Text("null"),
            trailing: GestureDetector(
                child: const Icon(Icons.open_in_new),
                onTap: () {
                  // navigate to organizer page
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => OrganizerInfo(organizerId: widget.ouid)));
                }),
          )
        : ListTile(
            leading: const CircleAvatar(
              maxRadius: 40,
              backgroundColor: Colors.blue,
            ),
            title: name != null ? Text(name!) : const Text("null"),
            trailing: GestureDetector(child: const Icon(Icons.open_in_new), onTap: () {}),
          );
  }
}
