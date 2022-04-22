import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream = FirebaseFirestore.instance
      .collection('userinfo')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('history')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("History"), centerTitle: true, elevation: 0),
        body: StreamBuilder(
            stream: collectionStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.lightBlue));
              }

              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot e) => ListTile(
                          tileColor: e["won"] == 0
                              ? Colors.red.withOpacity(0.3)
                              : e["won"] == 1
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.yellow.withOpacity(0.3),
                          leading: Text(e["matchType"]),
                          trailing: Text(e["won"] == 0
                              ? "Lost"
                              : e["won"] == 1
                                  ? "Lost"
                                  : "Match Cancelled"),
                        ))
                    .toList(),
              );
            }));
  }
}
