import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    fetchOrganizerData();
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
                    textScaleFactor: 1.2,
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
            onTap: () {}, // add or remove from fav func
            child: const Icon(
              Icons.star_border,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}
