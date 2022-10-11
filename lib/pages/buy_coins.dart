import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zbgaming/utils/apistring.dart';

class BuyCoins extends StatefulWidget {
  const BuyCoins({Key? key}) : super(key: key);

  @override
  State<BuyCoins> createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoins> {
  int? coins;
  List transactions = [];

  @override
  void initState() {
    super.initState();

    // fetch coins and transactions stream
    FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      coins = event["zcoins"];
      transactions = event["transactions"];
      transactions = transactions.reversed.toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff333399), Color(0xffff00cc)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // back button
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.amber,
                          size: 27,
                        ),
                      )
                    ]),
                  ),

                  // coins
                  Container(
                    height: MediaQuery.of(context).size.width / 4,
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ZCoinsYouHave(coins: coins)],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // scroll to view and tiles
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // list view
                      Container(
                        padding: const EdgeInsets.all(8),
                        height: 170,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: const [
                            BuyCoinsContainer(coinsValue: 100),
                            BuyCoinsContainer(coinsValue: 500),
                            BuyCoinsContainer(coinsValue: 1000),
                            BuyCoinsContainer(coinsValue: 5000),
                          ],
                          scrollDirection: Axis.horizontal,
                        ),
                      ),

                      // Transaction History
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "Transaction History",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                            ),
                            transactions.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Text("Nothing to show here"),
                                    color: Colors.white,
                                  )
                                : Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: transactions
                                          .map((e) => TransactionTile(
                                              timestamp: e["timestamp"], amount: e["amount"], type: e["type"]))
                                          .toList(),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          //  Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //     ],
          //   ),
        )),
      ),
    );
  }
}

// ZCOINS YOU HAVE
class ZCoinsYouHave extends StatefulWidget {
  const ZCoinsYouHave({Key? key, this.coins}) : super(key: key);
  final int? coins;

  @override
  State<ZCoinsYouHave> createState() => _ZCoinsYouHaveState();
}

class _ZCoinsYouHaveState extends State<ZCoinsYouHave> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minWidth: 50, minHeight: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(500)),
            color: Colors.white,
            border: Border.all(color: Colors.amber[700]!, width: 3)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Image(
              image: AssetImage("assets/images/zcoin.png"),
              height: 50,
            ),
            Text(
              widget.coins == null ? "Loading..." : "${widget.coins} coins",
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

// BUY COINS CONTAINERS
class BuyCoinsContainer extends StatefulWidget {
  const BuyCoinsContainer({Key? key, required this.coinsValue}) : super(key: key);

  final int coinsValue;

  @override
  State<BuyCoinsContainer> createState() => _BuyCoinsContainerState();
}

class _BuyCoinsContainerState extends State<BuyCoinsContainer> {
  bool isLoading = false;
  final Razorpay _razorpay = Razorpay();

  // FUNCTIONS
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    isLoading = true;
    setState(() {});
    // verify payment
    await get(Uri.parse(ApiEndpoints.baseUrl +
            ApiEndpoints.verifyOrderForCoins +
            "?order_id=${response.orderId}&payment_id=${response.paymentId}&signature=${response.signature}"))
        .then((value) {
      if (value.statusCode != 200) {
        Fluttertoast.showToast(msg: "Server Side error");
      } else {
        Fluttertoast.showToast(msg: value.body, textColor: Colors.white, backgroundColor: Colors.blue);
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Something went wrong");
    });
    isLoading = false;
    setState(() {});
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed!", backgroundColor: Colors.blue, textColor: Colors.white);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External wallet selected", backgroundColor: Colors.blue, textColor: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    // Razorpay event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 150, minHeight: 125),
        decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.amber, width: 2),
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [Color(0xff8E2DE2), Color(0xff4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.7])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                height: 75,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 35, child: Image.asset("assets/images/zcoin.png")),
                    Text(
                      "${widget.coinsValue}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  isLoading = true;
                  setState(() {});
                  await get(Uri.parse(ApiEndpoints.baseUrl +
                          ApiEndpoints.buyCoins +
                          "?uid=${FirebaseAuth.instance.currentUser!.uid}&type=${widget.coinsValue}"))
                      .then((value) {
                    if (value.statusCode != 200) {
                      Fluttertoast.showToast(
                          msg: "Server error", textColor: Colors.white, backgroundColor: Colors.blue);
                    } else {
                      if (value.body.contains("Failed")) {
                        Fluttertoast.showToast(msg: value.body, textColor: Colors.white, backgroundColor: Colors.blue);
                      } else {
                        try {
                          Fluttertoast.showToast(
                              msg: "Creating order...", textColor: Colors.white, backgroundColor: Colors.blue);
                          var result = jsonDecode(value.body);
                          var options = {
                            'key': 'rzp_test_rKi9TFV4sMHvz2',
                            'amount': result["amount"],
                            'name': 'ZBGaming',
                            'order_id': result['id'],
                            'timeout': 60,
                          };
                          _razorpay.open(options);
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Cannot create order at the moment",
                              textColor: Colors.white,
                              backgroundColor: Colors.blue);
                        }
                      }
                    }
                  }).catchError((e) {
                    Fluttertoast.showToast(
                        msg: "Somehting went wrong", textColor: Colors.white, backgroundColor: Colors.blue);
                  });
                  isLoading = false;
                  setState(() {});
                },
                child: isLoading
                    ? const SizedBox(height: 15, width: 15, child: CircularProgressIndicator(strokeWidth: 1))
                    : Text("₹ ${widget.coinsValue}"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                    elevation: MaterialStateProperty.all(0)),
              )
            ])
          ],
        ),
      ),
    );
  }
}

// TRANSACTION WIDGET
class TransactionTile extends StatelessWidget {
  const TransactionTile({Key? key, required this.timestamp, required this.amount, required this.type})
      : super(key: key);
  final Timestamp timestamp;
  final int amount;
  final String type;

  @override
  Widget build(BuildContext context) {
    Color color = type == "bought coins"
        ? Colors.green[700]!
        : type == "withdraw"
            ? Colors.red
            : type == "rewarded"
                ? Colors.green[700]!
                : type == "refunded"
                    ? Colors.green
                    : type == "joined game"
                        ? Colors.red
                        : Colors.black;
    String image = type == "bought coins"
        ? "assets/images/bank.png"
        : type == "withdraw"
            ? "assets/images/bank.png"
            : type == "rewarded"
                ? "assets/images/reward.png"
                : type == "refunded"
                    ? "assets/images/refund.png"
                    : type == "spent"
                        ? "assets/images/controller.png"
                        : "assets/images/bank.png";

    String time = timestamp.toDate().toUtc().toString().substring(0, 19);
    try {} catch (e) {
      time = "error occurred";
    }

    return ListTile(
      leading: SizedBox(
          height: 35,
          child: Image.asset(
            image,
            fit: BoxFit.fitHeight,
            color: color,
          )),
      title: Text(type),
      subtitle: Text(time),
      trailing: Text(
        amount >= 0 ? "+$amount" : "$amount",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
