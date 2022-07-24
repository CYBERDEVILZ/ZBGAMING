import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/pages/registered_users.dart';
import 'package:zbgaming/pages/show_user_account.dart';
import 'package:zbgaming/utils/apistring.dart';
import 'package:zbgaming/widgets/Date_to_string.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/organizer_card.dart';
import 'package:zbgaming/widgets/organizer_info.dart';
import 'package:zbgaming/widgets/rules_and_requirements.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ContestDetails extends StatefulWidget {
  const ContestDetails({Key? key, required this.uid, required this.matchType}) : super(key: key);
  final String uid;
  final String matchType;

  @override
  State<ContestDetails> createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  bool isLoading = false;
  bool isButtonLoading = false;
  bool isRegistered = false;
  String? token;
  DateToString dateString = DateToString();
  bool? special;
  String? name;
  bool? team;
  bool? tournament;
  int? skill;
  DateTime? date;
  int? rewards;
  int? regTeams;
  int? totalTeams;
  // organizer id
  String? ouid;
  Blob? winnerhash;
  String? winnerName;
  int? matchStarted;
  bool cancelled = false;

  void fetchMatchData() async {
    isLoading = true;
    setState(() {});

    FirebaseFirestore.instance.collection(widget.matchType).doc(widget.uid).snapshots().listen((value) async {
      try {
        special = value["special"];
        name = value["name"];
        team = value["solo"];
        tournament = value["match"];
        skill = value["skill"];
        date = value["date"].toDate();
        rewards = value["fee"];
        regTeams = value["reg"];
        totalTeams = value["total"];
        matchStarted = value["started"];
        ouid = value["uid"];
        try {
          winnerhash = value["winnerhash"];
          FirebaseFirestore.instance
              .collection("userinfo")
              .where("hashedID", isEqualTo: winnerhash)
              .snapshots()
              .listen((event) {
            winnerName = event.docs[0]["username"];
          });
        } catch (e) {
          winnerhash = null;
          if (matchStarted == 2) {
            cancelled = true;
          }
        }
        isLoading = false;
        setState(() {});
      } catch (e) {
        Fluttertoast.showToast(msg: "something went wrong", backgroundColor: Colors.blue);
        Navigator.pop(context);
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isButtonLoading = true;
    setState(() {});
    Fluttertoast.showToast(msg: "validating payment...");
    await get(Uri.parse(ApiEndpoints.baseUrl +
            ApiEndpoints.validateOrder +
            "?order_id=${response.orderId}&razorpay_signature=${response.signature}&razorpay_payment_id=${response.paymentId}&matchuid=${widget.uid}&useruid=${FirebaseAuth.instance.currentUser?.uid}&matchType=${widget.matchType}&token=$token&secretKey=DO_NOT_TAMPER_THIS_REQUEST"))
        .then((value) {
      if (value.statusCode == 200) {
        Fluttertoast.showToast(msg: value.body);
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Something Went Wrong!");
    });
    areYouRegistered();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Failure in handling payment");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Failure in handling external wallet");
  }

  final Razorpay _razorpay = Razorpay();

  void areYouRegistered() async {
    isButtonLoading = true;
    setState(() {});
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("registered")
        .get()
        .then((snapshots) {
      try {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshots.docs;
        for (int i = 0; i < data.length; i++) {
          if (data[i].id == widget.uid) {
            isRegistered = true;
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    });
    isButtonLoading = false;
    setState(() {});
  }

  void getToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  late Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream;

  @override
  void initState() {
    super.initState();
    documentStream = FirebaseFirestore.instance.collection(widget.matchType).doc(widget.uid).snapshots();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    areYouRegistered();
    fetchMatchData();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    final fee = (rewards == 1)
        ? 100
        : (rewards == 2)
            ? 500
            : (rewards == 3)
                ? 1000
                : (rewards == 4)
                    ? 5000
                    : null;
    final amount = (rewards == 1)
        ? "2,400"
        : (rewards == 2)
            ? "12,000"
            : (rewards == 3)
                ? "24,000"
                : (rewards == 4)
                    ? "1.2 Lacs"
                    : null;

    // contest details widget
    Widget contestDetails = isLoading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(name ?? "null",
                    textAlign: TextAlign.start,
                    textScaleFactor: 2,
                    style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 5),

                Row(children: [
                  // date of tournament
                  Text(
                    date == null ? "null" : dateString.dateToString(date!),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                  ),

                  const SizedBox(width: 20),

                  // teams registered
                  Row(
                    children: [
                      Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
                      Text(
                        " $regTeams/",
                        textScaleFactor: 1.1,
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                      Text(
                        "$totalTeams",
                        textScaleFactor: 1.1,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                      )
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegisteredUsers(matchType: widget.matchType, matchuid: widget.uid)));
                        },
                        child: const Text("View Registered Users")),
                  )
                ]),

                winnerhash == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: Colors.blueGrey[900],
                          child: Column(
                            children: [
                              const Text(
                                "🔥Match Winner🔥",
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowUserAccount(hashedId: winnerhash!)));
                                  },
                                  child: Text(
                                    "$winnerName",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 22, color: Color.fromARGB(255, 33, 212, 243)),
                                  )),
                              const SizedBox(height: 10),
                              Text(
                                "Click on the username to open profile page",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.blueGrey[700]),
                              )
                            ],
                          ),
                        ),
                      ),

                const Divider(height: 20),

                // match format
                const Align(child: Text("Match Format", textScaleFactor: 1.5, style: TextStyle(color: Colors.black))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 3),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                            SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: !team!
                                    ? [
                                        const Icon(Icons.people_alt, size: 25, color: Colors.purple),
                                        const SizedBox(width: 5),
                                        const Text("Team based\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                      ]
                                    : const [
                                        Icon(Icons.person, size: 25, color: Colors.purple),
                                        SizedBox(width: 5),
                                        Text("Solo based\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                      ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                children: !tournament!
                                    ? [
                                        Icon(Icons.account_tree_sharp, size: 25, color: Colors.blue[800]),
                                        const SizedBox(width: 5),
                                        Text("Tournament\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                                      ]
                                    : [
                                        Icon(Icons.play_arrow, size: 25, color: Colors.blue[800]),
                                        const SizedBox(width: 5),
                                        Text("Single Match\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                                      ],
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: skill! == 0
                                    ? const [
                                        Icon(Icons.flash_off, size: 25, color: Colors.teal),
                                        SizedBox(width: 5),
                                        Text("Rookie +\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                      ]
                                    : skill! == 1
                                        ? const [
                                            Icon(Icons.flash_on, size: 25, color: Colors.teal),
                                            SizedBox(width: 5),
                                            Text("Veteran +\n",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                          ]
                                        : skill! == 2
                                            ? const [
                                                Icon(Icons.flash_on, size: 25, color: Colors.teal),
                                                SizedBox(width: 5),
                                                Text("Only Master\nElites",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                              ]
                                            : const [
                                                Icon(Icons.flash_on, size: 25, color: Colors.teal),
                                                SizedBox(width: 5),
                                                Text("error occurred",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                              ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Align(
                            child: Column(
                              children: rewards != 0
                                  ? const [
                                      Icon(Icons.attach_money_outlined, size: 25, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text("Rewards available",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                                    ]
                                  : const [
                                      Icon(Icons.money_off, size: 25, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text("No Rewards",
                                          style:
                                              TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                                    ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // prize
                          rewards != 0
                              ? Container(
                                  height: 90,
                                  padding: const EdgeInsets.all(3),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(color: Colors.blue),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Winner gets",
                                        style: TextStyle(color: Colors.white),
                                        textScaleFactor: 1.3,
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          child: Text(
                                            "\u20b9 $amount or more",
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                            textScaleFactor: 4,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // organizer details
                const Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text("Organized By:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrganizerInfo(organizerId: ouid!)));
                  },
                  child: OrganizerCard(
                    ouid: ouid!,
                  ),
                ),

                const SizedBox(height: 30),

                // rules
                const Text("Rules", style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.7),
                Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: const Rules(),
                ),

                const SizedBox(height: 30),

                // requirements
                Container(
                    padding: const EdgeInsets.all(5),
                    color: const Color(0xFF333333),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Requirements",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textScaleFactor: 1.7),
                          Requirements(),
                        ])),

                const CustomDivider(indent: 0, height: 10, radius: false)
              ],
            ));

    // register button function
    void register() async {
      isButtonLoading = true;
      setState(() {});

      //check the auth status
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        Fluttertoast.showToast(msg: "Please login to register");
      }

      // if signed in,
      else {
        // calculate user level
        Response value = await get(Uri.parse(
            ApiEndpoints.baseUrl + ApiEndpoints.userLevelCalculate + "?uid=${FirebaseAuth.instance.currentUser?.uid}"));
        if (value.statusCode != 200) {
          Fluttertoast.showToast(msg: "Something went wrong");
          isButtonLoading = false;
          setState(() {});
          return;
        }
        if (value.body != "Success") {
          Fluttertoast.showToast(msg: "Something went wrong");
          isButtonLoading = false;
          setState(() {});
          return;
        }

        // fetch user level
        DocumentSnapshot<Map<String, dynamic>> data =
            await FirebaseFirestore.instance.collection("userinfo").doc(FirebaseAuth.instance.currentUser?.uid).get();
        if (skill == null) {
          isButtonLoading = false;
          setState(() {});
          return;
        } else {
          int currentLevel = data["level"];
          if (skill == 0) {
            if (currentLevel < 0) {
              Fluttertoast.showToast(msg: "Must be ROOKIE or greater to participate");
              isButtonLoading = false;
              setState(() {});
              return;
            }
          }
          if (skill == 1) {
            if (currentLevel < 5001) {
              Fluttertoast.showToast(msg: "Must be VETERAN or greater to participate");
              isButtonLoading = false;
              setState(() {});
              return;
            }
          }
          if (skill == 2) {
            if (currentLevel < 20001) {
              Fluttertoast.showToast(msg: "Must be VETERAN or greater to participate");
              isButtonLoading = false;
              setState(() {});
              return;
            }
          }
        }
        // if free register then and there
        if (rewards == 0) {
          if (regTeams! < totalTeams! && token != null) {
            await get(Uri.parse(ApiEndpoints.baseUrl +
                    ApiEndpoints.register +
                    "?matchType=${widget.matchType}&useruid=${FirebaseAuth.instance.currentUser?.uid}&matchuid=${widget.uid}&token=$token"))
                .then((value) {
              if (value.statusCode == 200) {
                Fluttertoast.showToast(msg: value.body);
                if (value.body == "Success") {
                  isRegistered = true;
                }
                setState(() {});
              } else {
                Fluttertoast.showToast(msg: "Something went wrong");
              }
            }).catchError((onError) {
              Fluttertoast.showToast(msg: "An error occurred");
            });
          }
        }

        // else accept payment
        else {
          if (regTeams! < totalTeams!) {
            String? token = await FirebaseMessaging.instance.getToken();

            await get(Uri.parse(ApiEndpoints.baseUrl +
                    ApiEndpoints.createOrder +
                    "?matchType=${widget.matchType}&useruid=${FirebaseAuth.instance.currentUser?.uid}&matchuid=${widget.uid}&token=$token"))
                .then((value) {
              if (value.statusCode == 200) {
                if (!value.body.contains("Failed")) {
                  Fluttertoast.showToast(msg: "redirecting you to payment gateway");
                  Map<String, dynamic> checkout = {
                    'key': 'rzp_test_rKi9TFV4sMHvz2',
                    'amount': fee! * 100, //in the smallest currency sub-unit.
                    'name': 'ZBGaming',
                    'order_id': value.body, // Generate order_id using Orders API
                    'description': 'Registration Fees',
                    'timeout': 300, // in seconds
                  };
                  _razorpay.open(checkout);
                } else {
                  Fluttertoast.showToast(msg: value.body);
                }
              } else {
                Fluttertoast.showToast(msg: "Something went wrong");
              }
            }).catchError((onError) {
              Fluttertoast.showToast(msg: "An error occurred");
            });
          }
        }
      }
      isButtonLoading = false;
      setState(() {});
    }

// --------------- Return is Here --------------- //
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(children: [
                Column(
                  children: [
                    // banner image
                    BannerImage(ouid: ouid!, matchType: widget.matchType),

                    // contest details
                    contestDetails,

                    // register button and number of teams
                    Container(
                      height: 75,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Container(
                            alignment: Alignment.center,
                            child: FittedBox(
                              child: rewards != 0
                                  ? Text(
                                      "\u20b9 $fee",
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
                                    )
                                  : const Text(
                                      "FREE",
                                      style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: documentStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                if (snapshot.hasError) {
                                  return ElevatedButton(
                                    onPressed: null,
                                    child: const Text('Something went wrong'),
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                                        elevation: MaterialStateProperty.all(0)),
                                  );
                                }

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return ElevatedButton(
                                    onPressed: null,
                                    child: const Text("Loading"),
                                    style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                                        elevation: MaterialStateProperty.all(0)),
                                  );
                                }
                                int a = snapshot.data!['started'];
                                String? text;
                                if (a == 0) {
                                  text = "Register";
                                }
                                if (a == 1) {
                                  text = "Ongoing";
                                }
                                if (a == 2) {
                                  text = "Finished";
                                }
                                return ElevatedButton(
                                  // register button
                                  onPressed: FirebaseAuth.instance.currentUser?.uid == null
                                      ? null
                                      : regTeams! == totalTeams!
                                          ? null
                                          : isRegistered
                                              ? null
                                              : a != 0
                                                  ? null
                                                  : () {
                                                      register();
                                                    },
                                  child: isButtonLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          a == 0
                                              ? isRegistered
                                                  ? "Registered"
                                                  : text!
                                              : text!,
                                          textScaleFactor: 1.3),
                                  style: ButtonStyle(
                                      fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                                      elevation: MaterialStateProperty.all(0)),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                cancelled
                    ? Positioned.fill(
                        child: Container(
                        color: Colors.white.withOpacity(0.9),
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/cancelled.png"),
                      ))
                    : Container()
              ]),
            ),
    );
  }
}

// banner image
class BannerImage extends StatefulWidget {
  const BannerImage({Key? key, required this.ouid, required this.matchType}) : super(key: key);
  final String ouid;
  final String matchType;

  @override
  // ignore: no_logic_in_create_state
  State<BannerImage> createState() => _BannerImageState(ouid, matchType);
}

class _BannerImageState extends State<BannerImage> {
  final String ouid;
  final String matchType;
  String? imageurl;

  _BannerImageState(this.ouid, this.matchType);

  // download and use banner
  void downloadBanner() async {
    try {
      Reference storage = FirebaseStorage.instance.ref("zbgaming/organizers/images/$ouid/banner.jpg");
      await storage.getDownloadURL().then((value) {
        imageurl = value;
        setState(() {});
      }).catchError((e) {});
    } catch (e) {
      imageurl = null;
    }
  }

  @override
  void initState() {
    super.initState();
    downloadBanner();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width,
      child: imageurl != null
          ? Image.network(
              imageurl!,

              // error builder
              errorBuilder: (context, error, stackTrace) => const Text(
                "Error occurred",
                style: TextStyle(color: Colors.red),
              ),

              // loading builder
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              // change the image to contest banner
              fit: BoxFit.cover,
            )
          : Image.asset("assets/images/$matchType.jpg", fit: BoxFit.cover),
    );
  }
}
