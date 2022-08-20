import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';

class RateBuilder extends StatefulWidget {
  const RateBuilder({Key? key, required this.uuid, required this.muid, required this.ouid}) : super(key: key);
  final String uuid;
  final String muid;
  final String ouid;
  @override
  State<RateBuilder> createState() => _RateBuilderState();
}

class _RateBuilderState extends State<RateBuilder> {
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  int rating = 0;
  bool isCancelled = false;

  @override
  Widget build(BuildContext context) {
    return isCancelled
        ? Container()
        : Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "How was the match?",
                  style: TextStyle(fontSize: 25, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        star1 = true;
                        star2 = false;
                        star3 = false;
                        star4 = false;
                        star5 = false;
                        rating = 1;
                        setState(() {});
                      },
                      child: star1
                          ? const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.star_border,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          star1 = true;
                          star2 = true;
                          star3 = false;
                          star4 = false;
                          star5 = false;
                          rating = 2;
                        });
                      },
                      child: star2
                          ? const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.star_border,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        star1 = true;
                        star2 = true;
                        star3 = true;
                        star4 = false;
                        star5 = false;
                        rating = 3;
                        setState(() {});
                      },
                      child: star3
                          ? const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.star_border,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        star1 = true;
                        star2 = true;
                        star3 = true;
                        star4 = true;
                        star5 = false;
                        rating = 4;
                        setState(() {});
                      },
                      child: star4
                          ? const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.star_border,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        star1 = true;
                        star2 = true;
                        star3 = true;
                        star4 = true;
                        star5 = true;
                        rating = 5;
                        setState(() {});
                      },
                      child: star5
                          ? const Icon(
                              Icons.star,
                              size: 40,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.star_border,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          isCancelled = true;
                          await FirebaseFirestore.instance
                              .collection("userinfo")
                              .doc(widget.uuid)
                              .collection("registered")
                              .doc(widget.muid)
                              .update({"hasRated": true});
                          setState(() {});
                        },
                        child: const Text("Cancel")),
                    ElevatedButton(
                      onPressed: () async {
                        isCancelled = true;
                        Fluttertoast.showToast(msg: "Thank you for your feedback");
                        setState(() {});
                        await FirebaseFirestore.instance
                            .collection("userinfo")
                            .doc(widget.uuid)
                            .collection("registered")
                            .doc(widget.muid)
                            .update({"hasRated": true});

                        // write logic for rating api here!!
                        await get(Uri.parse(
                            ApiEndpoints.baseUrl + ApiEndpoints.rate + "?ouid=${widget.ouid}&rating=$rating"));
                        setState(() {});
                      },
                      child: const Text("Submit"),
                      style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                    )
                  ],
                )
              ],
            ));
  }
}
