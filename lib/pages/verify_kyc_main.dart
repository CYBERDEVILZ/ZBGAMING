import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyKYCMain extends StatefulWidget {
  const VerifyKYCMain({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<VerifyKYCMain> createState() => _VerifyKYCMainState();
}

class _VerifyKYCMainState extends State<VerifyKYCMain> {
  // VARIABLES
  String? govtIdImageFront;
  String? govtIdImageBack;
  String? govtIdImageWithFace;
  bool isLoading = true;

  // FUNCTIONS
  fetchData() async {
    isLoading = true;
    if (mounted) setState(() {});
    await FirebaseFirestore.instance.collection("kycPending").doc(widget.uid).get().then((value) {
      if (value["assigned"] != null) {
        Fluttertoast.showToast(msg: "Another verifier is working");
        Navigator.pop(context);
        isLoading = false;
        if (mounted) setState(() {});
      } else {
        govtIdImageFront = value["govt_id_image_front"];
        govtIdImageBack = value["govt_id_image_back"];
        govtIdImageWithFace = value["govt_id_image_with_face"];
        isLoading = false;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("verify KYC"),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: RichText(
                            text: const TextSpan(
                                text: "Turn the phone into",
                                style: TextStyle(color: Colors.green),
                                children: [
                              TextSpan(
                                  text: " LANDSCAPE MODE ",
                                  style: TextStyle(color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold)),
                              TextSpan(text: "to view the images better.")
                            ])),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Govt ID Front",
                          style: TextStyle(color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2)),
                        child: AspectRatio(
                          aspectRatio: 1.77,
                          child: Image.network(
                            govtIdImageFront!,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("error occurred while loading image"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Govt ID Back",
                          style: TextStyle(color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2)),
                        child: AspectRatio(
                          aspectRatio: 1.77,
                          child: Image.network(
                            govtIdImageBack!,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("error occurred while loading image"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Govt ID With Face",
                          style: TextStyle(color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 2)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            govtIdImageWithFace!,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("error occurred while loading image"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                isLoading = true;
                                if (mounted) setState(() {});
                                await FirebaseFirestore.instance
                                    .collection("userinfo")
                                    .doc(widget.uid)
                                    .update({"isVerified": 1}).then((value) async {
                                  await FirebaseFirestore.instance.collection("kycPending").doc(widget.uid).delete();
                                  Navigator.pop(context);
                                }).catchError((onError) {
                                  Fluttertoast.showToast(msg: "something went wrong");
                                });
                                isLoading = false;
                                if (mounted) setState(() {});
                              },
                              child: const Text("Accept")),
                          ElevatedButton(
                              onPressed: () async {
                                isLoading = true;
                                if (mounted) setState(() {});
                                await FirebaseFirestore.instance
                                    .collection("userinfo")
                                    .doc(widget.uid)
                                    .update({"isVerified": 0}).then((value) async {
                                  await FirebaseFirestore.instance.collection("kycPending").doc(widget.uid).delete();
                                  Navigator.pop(context);
                                }).catchError((onError) {
                                  Fluttertoast.showToast(msg: "something went wrong");
                                });
                                isLoading = false;
                                if (mounted) setState(() {});
                              },
                              child: const Text("Reject"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
      )),
    );
  }
}
