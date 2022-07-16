import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectWinner extends StatefulWidget {
  const SelectWinner({Key? key, required this.matchType, required this.matchUid}) : super(key: key);
  final String matchType;
  final String matchUid;

  @override
  State<SelectWinner> createState() => _SelectWinnerState();
}

class _SelectWinnerState extends State<SelectWinner> {
  void fetchData() async {
    FirebaseFirestore.instance
        .collection(widget.matchType)
        .doc(widget.matchUid)
        .collection("registeredUsers")
        .snapshots()
        .listen((snapshots) {});
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
        appBar: AppBar(
          title: const Text("Select the winner"),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(),
      ),
    );
  }
}
