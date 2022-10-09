import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';

class BuyCoins extends StatefulWidget {
  const BuyCoins({Key? key}) : super(key: key);

  @override
  State<BuyCoins> createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoins> {
  int? coins;

  @override
  void initState() {
    super.initState();

    // fetch coins stream subscription
    FirebaseFirestore.instance
        .collection("userinfo")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      coins = event["zcoins"];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: "Navigate to recent transactions");
                  },
                  child: const Icon(
                    Icons.history_sharp,
                    color: Colors.black,
                    size: 27,
                  ),
                )
              ]),
            ),
            Container(
              height: MediaQuery.of(context).size.width / 4,
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ZCoinsYouHave(coins: coins)],
              ),
            ),

            // scroll to view and tiles
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("scroll to view more >>>"),
                ),

                // list view
                SizedBox(
                  height: 170,
                  child: ListView(
                    children: const [
                      BuyCoinsContainer(coinsValue: 100),
                      BuyCoinsContainer(coinsValue: 500),
                      BuyCoinsContainer(coinsValue: 1000),
                      BuyCoinsContainer(coinsValue: 5000),
                    ],
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ]),
            ),

            // Transaction History
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 10),
              child: const Text(
                "Transaction History",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),

            // Transaction History shown here
          ],
        ),
      )),
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
        padding: const EdgeInsets.all(5),
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
              widget.coins == null ? "Loading..." : "${widget.coins}",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 150, minHeight: 125),
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
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
                  // RAZORPAY INTEGRATION!!
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
