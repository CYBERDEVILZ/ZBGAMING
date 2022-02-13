import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrganizerInfo extends StatefulWidget {
  const OrganizerInfo({Key? key, required this.organizerId}) : super(key: key);
  final String organizerId;

  @override
  _OrganizerState createState() => _OrganizerState();
}

class _OrganizerState extends State<OrganizerInfo> {
  bool isLoading = false;
  String? bannerurl;
  String? imageurl;
  String? name;
  String? email;
  bool? special;

  void fetchOrganizerData() async {
    isLoading = true;
    setState(() {});
    final FirebaseFirestore _storeInstance = FirebaseFirestore.instance;
    await _storeInstance.collection("organizer").doc(widget.organizerId).get().then((value) {
      bannerurl = value["bannerurl"];
      imageurl = value["imageurl"];
      name = value["username"];
      email = value["email"];
      special = value["special"];
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
    // --------------- Return is Here --------------- //
    return Scaffold(
      body: SingleChildScrollView(
          child: isLoading
              ? Column(children: const [SizedBox(height: 50), Center(child: CircularProgressIndicator())])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("banner"),
                    Text("image"),
                    Text("name"),
                    Text("rating"),
                    Text("email"),
                    Text("organized matches"),
                    Text("Prizes given"),
                  ],
                )),
    );
  }
}
