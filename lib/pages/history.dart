import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/date_to_string.dart';

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
      .orderBy("date", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
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
                      .map((DocumentSnapshot e) => Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                    child: Image.asset(
                                      "assets/images/" + e["matchType"] + ".jpg",
                                      width: 100,
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  e["name"],
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(DateToString().dateToString(e["date"].toDate())),
                                trailing: e["won"] == -1
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Text("Registered"),
                                      )
                                    : e["won"] == 0
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.red.withOpacity(0.3),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: const Text("Lost"),
                                          )
                                        : e["won"] == 1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.green.withOpacity(0.3),
                                                ),
                                                padding: const EdgeInsets.all(8),
                                                child: const Text("Won"),
                                              )
                                            : e["won"] == 2
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.yellow.withOpacity(0.3),
                                                    ),
                                                    padding: const EdgeInsets.all(8),
                                                    child: const Text("Cancelled"),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.red.withOpacity(0.3),
                                                    ),
                                                    padding: const EdgeInsets.all(8),
                                                    child: const Text("Error"),
                                                  ),
                              ),
                              const Divider(
                                height: 0,
                                color: Colors.blue,
                              )
                            ],
                          ))
                      .toList(),
                );
              })),
    );
  }
}
