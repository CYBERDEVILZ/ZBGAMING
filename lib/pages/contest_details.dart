import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/pages/registered_users.dart';
import 'package:zbgaming/utils/apistring.dart';
import 'package:zbgaming/widgets/Date_to_string.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/organizer_card.dart';
import 'package:zbgaming/widgets/organizer_info.dart';
import 'package:zbgaming/widgets/rules_and_requirements.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ContestDetails extends StatefulWidget {
  const ContestDetails(
      {Key? key,
      required this.special,
      required this.name,
      required this.team,
      required this.tournament,
      required this.skill,
      required this.date,
      required this.rewards,
      required this.regTeams,
      required this.totalTeams,
      required this.uid,
      required this.matchType,
      required this.ouid})
      : super(key: key);
  final bool special;
  final String name;
  final bool team;
  final bool tournament;
  final int skill;
  final DateTime date;
  final int rewards;
  final int regTeams;
  final int totalTeams;
  // uid of match
  final String uid;
  // organizer id
  final String ouid;
  final String matchType;

  @override
  State<ContestDetails> createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  bool isLoading = false;
  bool isRegistered = false;
  DateToString dateString = DateToString();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isLoading = true;
    setState(() {});
    Fluttertoast.showToast(msg: "Payment Success");
    await get(Uri.parse(ApiEndpoints.baseUrl +
            ApiEndpoints.validateOrder +
            "?order_id=${response.orderId}&razorpay_signature=${response.signature}&razorpay_payment_id=${response.paymentId}&matchuid=${widget.uid}&useruid=${FirebaseAuth.instance.currentUser?.uid}&matchType=${widget.matchType}&secretKey=DO_NOT_TAMPER_THIS_REQUEST"))
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
    Fluttertoast.showToast(msg: "Fail");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "Wallet");
  }

  final Razorpay _razorpay = Razorpay();

  void areYouRegistered() async {
    isLoading = true;
    setState(() {});
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("registered")
        .get()
        .then((snapshots) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshots.docs;
      for (int i = 0; i < data.length; i++) {
        if (data[i].id == widget.uid) {
          isRegistered = true;
        }
      }
    });
    isLoading = false;
    setState(() {});
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
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    final fee = (widget.rewards == 1)
        ? 100
        : (widget.rewards == 2)
            ? 500
            : (widget.rewards == 3)
                ? 1000
                : (widget.rewards == 4)
                    ? 5000
                    : null;
    final amount = (widget.rewards == 1)
        ? "2,400"
        : (widget.rewards == 2)
            ? "12,000"
            : (widget.rewards == 3)
                ? "24,000"
                : (widget.rewards == 4)
                    ? "1.2 Lacs"
                    : null;

    // contest details widget
    Widget contestDetails = Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(widget.name,
                textAlign: TextAlign.start, textScaleFactor: 2, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Row(children: [
              // date of tournament
              Text(
                dateString.dateToString(widget.date),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
              ),

              const SizedBox(width: 20),

              // teams registered
              Row(
                children: [
                  Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
                  Text(
                    " ${widget.regTeams}/",
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                  Text(
                    "${widget.totalTeams}",
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

            const Divider(height: 50),

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
                            children: widget.team
                                ? [
                                    const Icon(Icons.people_alt, size: 25, color: Colors.purple),
                                    const SizedBox(width: 5),
                                    const Text("Team based\n",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                  ]
                                : const [
                                    Icon(Icons.person, size: 25, color: Colors.purple),
                                    SizedBox(width: 5),
                                    Text("Solo based\n",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                  ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            children: widget.tournament
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
                            children: widget.skill == 0
                                ? const [
                                    Icon(Icons.flash_off, size: 25, color: Colors.teal),
                                    SizedBox(width: 5),
                                    Text("Rookie +\n",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                  ]
                                : widget.skill == 1
                                    ? const [
                                        Icon(Icons.flash_on, size: 25, color: Colors.teal),
                                        SizedBox(width: 5),
                                        Text("Veteran +\n",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                      ]
                                    : widget.skill == 2
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
                          children: widget.rewards != 0
                              ? const [
                                  Icon(Icons.attach_money_outlined, size: 25, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text("Rewards available",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                                ]
                              : const [
                                  Icon(Icons.money_off, size: 25, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text("No Rewards",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                                ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // prize
                      widget.rewards != 0
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => OrganizerInfo(organizerId: widget.ouid)));
              },
              child: OrganizerCard(
                ouid: widget.ouid,
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
      isLoading = true;
      setState(() {});

      //check the auth status
      if (FirebaseAuth.instance.currentUser?.uid == null) {
        Fluttertoast.showToast(msg: "Please login to register");
      }

      // if signed in,
      else {
        // if free register then and there
        if (widget.rewards == 0) {
          String? token = await FirebaseMessaging.instance.getToken();

          if (widget.regTeams < widget.totalTeams && token != null) {
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
          if (widget.regTeams < widget.totalTeams) {
            await get(Uri.parse(ApiEndpoints.baseUrl +
                    ApiEndpoints.createOrder +
                    "?matchType=${widget.matchType}&useruid=${FirebaseAuth.instance.currentUser?.uid}&matchuid=${widget.uid}"))
                .then((value) {
              if (value.statusCode == 200) {
                if (value.body.isNotEmpty) {
                  Fluttertoast.showToast(msg: "order created");
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
                  Fluttertoast.showToast(msg: "Failed to create order");
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
      isLoading = false;
      setState(() {});
    }

// --------------- Return is Here --------------- //
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // banner image
            BannerImage(ouid: widget.ouid, matchType: widget.matchType),

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
                      child: widget.rewards != 0
                          ? Text(
                              "\u20b9 $fee",
                              style: const TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
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
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
                              : widget.regTeams == widget.totalTeams
                                  ? null
                                  : isRegistered
                                      ? null
                                      : a != 0
                                          ? null
                                          : () {
                                              register();
                                            },
                          child: isLoading
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
    Reference storage = FirebaseStorage.instance.ref("zbgaming/organizers/images/$ouid/banner.jpg");
    await storage.getDownloadURL().then((value) {
      imageurl = value;
      setState(() {});
    }).catchError((e) {});
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
