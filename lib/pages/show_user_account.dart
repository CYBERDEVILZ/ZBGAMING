import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';
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
  String? userLevel;

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

      // calculating user level
      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(data[0].id)
          .collection("history")
          .where("paid", isNotEqualTo: 0)
          .get()
          .then((value) {
        int participation = 0;
        int won = 0;
        if (value.docs.isEmpty) {
          level = 0;
        } else {
          participation = (value.docs.length) * 20;
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = value.docs;
          docs.map((e) {
            int wonMatches = e["won"];
            if (wonMatches == 1) {
              int paid = e["paid"];
              if (paid == 1) {
                won += 300;
              }
              if (paid == 2) {
                won += 500;
              }
              if (paid == 3) {
                won += 1500;
              }
              if (paid == 4) {
                won += 2000;
              } else {
                won += 0;
              }
            }
          });
          level = won + participation;
        }
      });

      if (level != null) {
        if (level! <= 5000) {
          userLevel = "ROOKIE";
        } else if (level! <= 20000) {
          userLevel = "VETERAN";
        } else if (level! >= 20001) {
          userLevel = "ELITE";
        } else {
          userLevel = null;
        }
      }

      isLoading = false;
      setState(() {});

      await FirebaseFirestore.instance
          .collection("userinfo")
          .doc(data[0].id)
          .collection("history")
          .where("won", isEqualTo: 1)
          .get()
          .then((value) {
        totalMatchesWon = value.docs;
        isMatchesLoading = false;
        setState(() {});
      }).catchError((onError) {
        Fluttertoast.showToast(msg: "Some error occurred");
        isMatchesLoading = false;
        setState(() {});
      });
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Some error occurred");
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 5, 26),
        body: SingleChildScrollView(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Image.asset(
                        "assets/images/zbunker-app-banner-upsidedown-short.png",
                        fit: BoxFit.fitWidth,
                      ),
                      const CircleAvatar(
                        maxRadius: 70,
                      ),
                      const SizedBox(height: 30),
                      ShadowedContainer(
                        anyWidget: Text(
                          name!,
                          style: const TextStyle(
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
                                  text: TextSpan(
                                      text: "Level: ",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text: userLevel,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300))
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300))
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300))
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Tournament name",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Date here"),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child:
                                                        Text("Amount won here"),
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
