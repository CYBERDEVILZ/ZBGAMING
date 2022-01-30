import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/widgets/star_builder.dart';

class OrganizerCard extends StatefulWidget {
  const OrganizerCard({Key? key, required this.ouid}) : super(key: key);
  final String ouid;

  @override
  // ignore: no_logic_in_create_state
  State<OrganizerCard> createState() => _OrganizerCardState(ouid);
}

class _OrganizerCardState extends State<OrganizerCard> {
  String? imageurl;
  String? name;
  num? rating;
  String ouid;
  bool isLoading = false;
  bool isNotEligible = false;
  bool isFound = false;

  List<QueryDocumentSnapshot> fav = [];

  _OrganizerCardState(this.ouid);

  // fetch data
  void fetchOrganizerData() async {
    await FirebaseFirestore.instance.collection("organizer").doc(ouid).get().then((value) {
      imageurl = value["imageurl"];
      name = value["username"];
      rating = value["rating"];
    }).catchError((e) {});
    setState(() {});
  }

  // check if the org is added to fav
  void isFavOrg() async {
    isLoading = true;
    setState(() {});
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      isNotEligible = true;
      isLoading = false;
      setState(() {});
    } else {
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("favOrganizers")
          .get()
          .then((value) {
        fav = value.docs;
      }).catchError((onError) {
        Fluttertoast.showToast(msg: "Error occurred while fetching data.");
      });
    }

    for (int i = 0; i < fav.length; i++) {
      try {
        if (ouid == fav[i]["ouid"]) {
          isFound = true;
          break;
        }
      } catch (e) {
        null;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  // add organizer to fav
  Future<void> addOrg() async {
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("favOrganizers")
        .doc(ouid)
        .set({"ouid": ouid});
  }

  // remove organizer from fav
  Future<void> removeOrg() async {
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("favOrganizers")
        .doc(ouid)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    fetchOrganizerData();
    isFavOrg();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage("assets/images/zbunker-app-banner.png"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // network image
          Stack(clipBehavior: Clip.none, children: [
            const Positioned(bottom: -2, right: -2, child: CircleAvatar(radius: 42, backgroundColor: Colors.white)),
            imageurl == null
                ? const CircleAvatar(radius: 40, child: CircularProgressIndicator())
                : CircleAvatar(radius: 40, foregroundImage: NetworkImage(imageurl!))
          ]),

          // tournament name and rating
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name == null ? "Null" : name!,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.5,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  rating == null
                      ? const Text(
                          "Unrated",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : StarBuilder(
                          star: rating!,
                          starColor: Colors.white,
                          size: 20,
                        )
                ],
              ),
            ),
          ),

          // add to fav
          GestureDetector(
              onTap: isLoading
                  ? null
                  : isNotEligible
                      ? () {
                          Fluttertoast.showToast(msg: "Login to perform this action");
                        }
                      : isFound
                          ? () async {
                              await removeOrg();
                              isFound = false;
                              setState(() {});
                            }
                          : () async {
                              await addOrg();
                              isFound = true;
                              setState(() {});
                            }, // add or remove from fav func
              child: isFound
                  ? const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  : const Icon(
                      Icons.star_border,
                      color: Colors.white,
                    ))
        ]),
      ),
    );
  }
}
