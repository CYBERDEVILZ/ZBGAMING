import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/widgets/custom_colorful_container.dart';

List<String> maWon = [
  "sldkfjskldf",
  "slkjfslkdf",
  "lskjdflskdfj",
  "lskdjfslkdfj",
  "lskdjfslkdfj",
  "lskdjfslkdfj",
  "lskdjfslkdfj",
  "lskdjfslkdfj",
];

class ShowUserAccount extends StatefulWidget {
  const ShowUserAccount({Key? key, required this.hashedId}) : super(key: key);
  final Blob hashedId;

  @override
  State<ShowUserAccount> createState() => _ShowUserAccountState();
}

class _ShowUserAccountState extends State<ShowUserAccount> {
  bool isLoading = true;
  bool isMatchesLoading = true;
  String? name;
  String? imgurl;
  int? level;
  int? matchesWon;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? totalMatchesWon;

  void fetchData() async {
    await FirebaseFirestore.instance
        .collection("userinfo")
        .where("hashedID", isEqualTo: widget.hashedId)
        .get()
        .then((value) async {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data = value.docs;
      if (data.length != 1) {
        Fluttertoast.showToast(msg: "Some error occurred");
        Navigator.pop(context);
      }
      name = data[0]["username"];
      imgurl = data[0]["imageurl"];
      level = data[0]["level"];

      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(data[0].id)
          .collection("history")
          .where("won", isEqualTo: 1)
          .get()
          .then((value) {
        totalMatchesWon = value.docs;
        setState(() {
          isMatchesLoading = false;
        });
      }).catchError((onError) {
        Fluttertoast.showToast(msg: "Some error occurred");
        isMatchesLoading = false;
        setState(() {});
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Some error occurred");
      Navigator.pop(context);
      isMatchesLoading = false;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 5, 26),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Image.asset(
              "assets/images/zbunker-app-banner-upsidedown-short.png",
              fit: BoxFit.fitWidth,
            ),
            const CircleAvatar(
              maxRadius: 70,
            ),
            const SizedBox(height: 30),
            const ShadowedContainer(
              anyWidget: Text(
                "CYBERDEVILZ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            ShadowedContainer(
              anyWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    RichText(
                        text: const TextSpan(
                            text: "Level: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: "VETERAN",
                              style: TextStyle(fontWeight: FontWeight.w300))
                        ])),
                    const SizedBox(height: 20),
                    RichText(
                        text: const TextSpan(
                            text: "Total Matches Won: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: "32",
                              style: TextStyle(fontWeight: FontWeight.w300))
                        ])),
                    const SizedBox(height: 20),
                    RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            text: "Amounts Won: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "12000000",
                                  style: TextStyle(fontWeight: FontWeight.w300))
                            ])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ShadowedContainer(
                anyWidget: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Matches Won",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...maWon.map((element) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircleAvatar(),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tournament name",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Date here"),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text("Amount won here"),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                            ],
                          )),
                    );
                  }).toList(),
                ],
              ),
            )),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
  }
}
