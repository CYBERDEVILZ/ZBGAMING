import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/pages/login.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  String? name;
  String? imageurl;
  String? lvl;
  String? email;
  bool? isEmailVerified;
  bool isVerifying = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void fetchData() async {
    isLoading = true;
    setState(() {});
    await FirebaseFirestore.instance.collection("userinfo").doc(_auth.currentUser!.uid).get().then((value) {
      name = value["username"];
      imageurl = value["imageurl"];
      email = value["email"];
      isEmailVerified = _auth.currentUser!.emailVerified;
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Error getting data");
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _auth.userChanges().listen((event) {
      if (event?.uid == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        setState(() {});
      }
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // Name Widget
    Widget nameWidget = Text(
      name == null ? "null" : name!,
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.blue),
    );

    // Email Widget
    Widget emailWidget = Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 16 - 100,
        ),
        child: Text(
          email == null ? "null" : email!,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 10),
      isEmailVerified == true
          ? const Icon(
              Icons.verified_rounded,
              color: Colors.blue,
              size: 15,
            )
          : GestureDetector(
              // verify email logic here
              onTap: () async {
                isVerifying = true;
                setState(() {});
                await _auth.currentUser?.sendEmailVerification().then((value) async {
                  await Fluttertoast.showToast(
                      msg: "Verify mail and login again", textColor: Colors.white, backgroundColor: Colors.blue);
                  await _auth.signOut();
                }).catchError((onError) {
                  Fluttertoast.showToast(
                      msg: "Something went wrong.", textColor: Colors.white, backgroundColor: Colors.blue);
                });

                isVerifying = false;
                setState(() {});
              },
              child: Container(
                  height: 18,
                  width: 80,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: Colors.blue)),
                  child: isVerifying
                      ? const SizedBox(width: 18, child: LinearProgressIndicator(color: Colors.blue))
                      : const Text(
                          " verify email ",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        )))
    ]);

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Account",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  nameWidget,
                  emailWidget,
                  Text("Is Verified?(KYC)"),
                  Text("Link Accounts csgo, pubg, valo, freefire"),
                  Text("Link Bank Account"),
                ],
              ),
      ),
    );
  }
}
