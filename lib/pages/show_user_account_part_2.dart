import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zbgaming/model/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:zbgaming/utils/apistring.dart';

Map<String, Color> colorCodeForHeading = {
  "Unidentified": Colors.blue,
  "Rookie": Colors.blue,
  "Veteran": const Color(0xffB3E3EE),
  "Master Elite": const Color(0xFFFFD700)
};

Map<String, Color> colorCodeForText = {
  "Unidentified": Colors.black,
  "Rookie": Colors.black,
  "Veteran": Colors.white,
  "Master Elite": Colors.white
};

Map<String, Color> colorCodeForButtonTextCumCanvas = {
  "Unidentified": Colors.white,
  "Rookie": Colors.white,
  "Veteran": const Color(0xff00334c),
  "Master Elite": Colors.black
};

Map<String, Color> colorCodeForCanvas = {
  "Unidentified": Colors.white,
  "Rookie": Colors.white,
  "Veteran": const Color(0xff00334c),
  "Master Elite": Colors.black
};

class ShowUserAccountAlternative extends StatefulWidget {
  const ShowUserAccountAlternative({Key? key, required this.uuid}) : super(key: key);
  final String uuid;

  @override
  State<ShowUserAccountAlternative> createState() => _ShowUserAccountAlternativeState();
}

class _ShowUserAccountAlternativeState extends State<ShowUserAccountAlternative> {
  String? name;
  String? imageurl;
  String? lvl;
  int? level;
  String levelAttrib = "Unidentified";
  bool? isKYCVerified;
  bool isVerifying = false;
  bool isLoading = false;
  bool isImageLoad = false;
  bool? bankStatus;
  int? amount;
  QueryDocumentSnapshot<Map<String, dynamic>>? doc;
  int? query1;
  int? query2;

  TextEditingController passValue = TextEditingController();

  late Stream<DocumentSnapshot<Map<String, dynamic>>> accountData;

  void fetchData() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }

    // calculate user level
    await get(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.userLevelCalculateAlternative + "?uid=${widget.uuid}"))
        .then((value) async {
      if (value.statusCode != 200) {
        Fluttertoast.showToast(msg: "Something went wrong :(");
      } else {
        if (value.body == "Failed") {
          Fluttertoast.showToast(msg: "Something went wrong :(");
        }
      }
    });

    // fetch data
    await FirebaseFirestore.instance
        .collection("userinfo")
        .where("tempUid", isEqualTo: widget.uuid)
        .get()
        .then((value) async {
      if (value.docs.length == 1) {
        doc = value.docs[0];
        name = doc!["username"];
        level = doc!["level"];
        if (level! <= 5000) {
          levelAttrib = "Rookie";
        } else if (level! <= 20000) {
          levelAttrib = "Veteran";
        } else if (level! > 20000) {
          levelAttrib = "Master Elite";
        } else {
          levelAttrib = "Unidentified";
        }

        // get the number of paid matches won
        await doc!.reference
            .collection("history")
            .where("won", isEqualTo: 1)
            .where("paid", isNotEqualTo: 0)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            amount = 0;
          }
          num start = 0;
          for (var doca in value.docs) {
            start = start + doca["amount"];
          }
          amount = start.toInt();
        }).catchError((onError) {
          Fluttertoast.showToast(msg: "Error occurred");
        });
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Something went wrong");
    });

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // fetch data
    fetchData();
  }

  void imageUpload() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 250, maxWidth: 250);
    if (image != null) {
      isImageLoad = true;
      if (mounted) setState(() {});
      await FirebaseStorage.instance
          .ref("zbgaming/users/images/${widget.uuid}/profile.jpg")
          .putFile(File(image.path))
          .then((p0) async {
        if (p0.state == TaskState.success) {
          String imageurl = await p0.ref.getDownloadURL();
          context.read<UserModel>().setimageurl(imageurl);
          await FirebaseFirestore.instance.collection("userinfo").doc(widget.uuid).update({"imageurl": imageurl});
          Fluttertoast.showToast(
              msg: "Image Uploaded Successfully",
              textColor: colorCodeForButtonTextCumCanvas[levelAttrib],
              backgroundColor: colorCodeForHeading[levelAttrib]);
        }
        if (p0.state == TaskState.error) {
          Fluttertoast.showToast(
            msg: "Some error occurred",
            backgroundColor: colorCodeForHeading[levelAttrib],
            textColor: colorCodeForButtonTextCumCanvas[levelAttrib],
          );
        }
      }).catchError((onError) {
        Fluttertoast.showToast(
          msg: "Some error occurred",
          backgroundColor: colorCodeForHeading[levelAttrib],
          textColor: colorCodeForButtonTextCumCanvas[levelAttrib],
        );
      });
    }
    isImageLoad = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Matches Won Stream Builder Widget
    Widget amountCard = Card(
      child: Container(
        color: colorCodeForHeading[levelAttrib],
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Total Amount Won",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25, color: colorCodeForCanvas[levelAttrib])),
              const SizedBox(height: 3),
              SizedBox(
                height: 80,
                child: FittedBox(
                  child: Text("\u20B9$amount",
                      style: TextStyle(color: colorCodeForCanvas[levelAttrib], fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );

    // Image Widget
    Widget imageWidget = Stack(clipBehavior: Clip.none, children: [
      // blue rectangle in the back
      Container(
        color: colorCodeForHeading[levelAttrib],
        height: 125,
        width: MediaQuery.of(context).size.width,
      ),

      // background circle
      Positioned(
        bottom: -40,
        left: MediaQuery.of(context).size.width / 2 - 55,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: colorCodeForButtonTextCumCanvas[levelAttrib],
              radius: 55,
            ),
            // inside circle
            Positioned(
                left: 5,
                top: 5,
                child: GestureDetector(
                  // image select and upload code
                  onTap: () {
                    imageUpload();
                  },
                  child: CircleAvatar(
                    backgroundColor: colorCodeForHeading[levelAttrib],
                    radius: 50,
                    child: isImageLoad
                        ? CircularProgressIndicator(
                            color: context.watch<UserModel>().imageurl == null
                                ? colorCodeForButtonTextCumCanvas[levelAttrib]
                                : colorCodeForHeading[levelAttrib])
                        : Icon(Icons.add_a_photo_outlined,
                            color: context.watch<UserModel>().imageurl == null
                                ? colorCodeForButtonTextCumCanvas[levelAttrib]
                                : colorCodeForHeading[levelAttrib]),
                    backgroundImage: context.watch<UserModel>().imageurl == null
                        ? null
                        : NetworkImage(context.watch<UserModel>().imageurl!),
                  ),
                )),
          ],
        ),
      ),
    ]);

    // Level Widget
    Widget levelWidget = Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // if level == null
          level == null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text(
                    "Unidentified",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ))

              // if level == rookie
              : level! <= 5000
                  ? Container(
                      margin: const EdgeInsets.only(top: 3),
                      child: const Text(
                        "Rookie",
                        style: TextStyle(
                            fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      ))

                  // if level == veteran
                  : level! <= 20000
                      ? Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: Text(
                            "Veteran",
                            style: TextStyle(
                                fontSize: 15,
                                color: colorCodeForHeading[levelAttrib],
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ))

                      // if level == elite
                      : level! > 20000
                          ? Container(
                              margin: const EdgeInsets.only(top: 3),
                              child: const Text(
                                "Master Elite",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0XFFFFD700),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ))

                          // if level == invalid
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                              margin: const EdgeInsets.only(top: 5),
                              child: const Text(
                                "Invalid",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              )),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width / 2 - 63,
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "$level",
                        style: TextStyle(fontWeight: FontWeight.w300, color: colorCodeForHeading[levelAttrib]),
                      ),
                    ),
                  ),
                ),
                Text(
                  "pts",
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorCodeForHeading[levelAttrib]),
                )
              ],
            ),
          )
        ]));

    // Name Widget
    Widget nameWidget = Text(name == null ? "null" : name!,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: colorCodeForHeading[levelAttrib],
        ));

    Stream<QuerySnapshot>? matchesPlayed = doc == null
        ? null
        : FirebaseFirestore.instance
            .collection("userinfo")
            .doc(doc!.id)
            .collection("history")
            .where("won", isEqualTo: 1)
            .snapshots();

    // GRAPH WIDGET
    Widget graphBuilder = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Matches Won",
            style: TextStyle(color: colorCodeForText[levelAttrib], fontSize: 25, fontWeight: FontWeight.w300),
          ),
        ),
        StreamBuilder(
            stream: matchesPlayed,
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              if (snapshot.hasError) {
                return const Text("Error occurred");
              }
              if (!snapshot.hasData) {
                return const Text("No data");
              }
              int free = 0;
              int hundred = 0;
              int fivehundred = 0;
              int thousand = 0;
              int fivethousand = 0;
              List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
              for (var e in data) {
                if (e["paid"] == 0) {
                  free += 1;
                }
                if (e["paid"] == 1) {
                  hundred += 1;
                }
                if (e["paid"] == 2) {
                  fivehundred += 1;
                }
                if (e["paid"] == 3) {
                  thousand += 1;
                }
                if (e["paid"] == 4) {
                  fivethousand += 1;
                }
              }
              // graph
              return Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 50),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: free == 0 && hundred == 0 && fivehundred == 0 && thousand == 0 && fivethousand == 0
                      ? Text(
                          "Nothing to show here",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorCodeForHeading[levelAttrib]),
                        )
                      : RadarChart(
                          RadarChartData(
                              radarShape: RadarShape.polygon,
                              radarBorderData:
                                  BorderSide(color: colorCodeForText[levelAttrib]!.withOpacity(0.3), width: 2),
                              gridBorderData:
                                  BorderSide(color: colorCodeForText[levelAttrib]!.withOpacity(0.3), width: 2),
                              radarBackgroundColor: Colors.transparent,
                              tickBorderData: const BorderSide(color: Colors.transparent),
                              tickCount: 1,
                              titlePositionPercentageOffset: 0.2,
                              ticksTextStyle: const TextStyle(color: Colors.transparent),
                              titleTextStyle: TextStyle(
                                  color: colorCodeForHeading[levelAttrib], fontWeight: FontWeight.bold, fontSize: 16),
                              getTitle: (index, angle) {
                                switch (index) {
                                  case (0):
                                    return RadarChartTitle(text: "FREE\n($free)");
                                  case (1):
                                    return RadarChartTitle(text: "\u20b9100\n($hundred)");
                                  case (2):
                                    return RadarChartTitle(text: "\u20b9500\n($fivehundred)");
                                  case (3):
                                    return RadarChartTitle(text: "\u20b91000\n($thousand)");
                                  case (4):
                                    return RadarChartTitle(text: "\u20b95000\n($fivethousand)");
                                  default:
                                    return const RadarChartTitle(text: "");
                                }
                              },
                              dataSets: <RadarDataSet>[
                                RadarDataSet(borderColor: colorCodeForHeading[levelAttrib], dataEntries: [
                                  RadarEntry(value: free.toDouble()),
                                  RadarEntry(value: hundred.toDouble()),
                                  RadarEntry(value: fivehundred.toDouble()),
                                  RadarEntry(value: thousand.toDouble()),
                                  RadarEntry(value: fivethousand.toDouble())
                                ]),
                              ]),
                          swapAnimationDuration: const Duration(milliseconds: 500), // Optional
                          swapAnimationCurve: Curves.ease,
                        ),
                ),
              );
            })),
      ],
    );

    // --------------- Return is Here --------------- //
    return Scaffold(
      backgroundColor: colorCodeForButtonTextCumCanvas[levelAttrib],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  imageWidget,
                  levelWidget,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        nameWidget,
                        const SizedBox(height: 30),
                        amountCard,
                        const SizedBox(height: 30),
                        graphBuilder,
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
