// responsible for fetching match based on the name of match and organizer id

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/pages/contest_details.dart';
import 'package:zbgaming/widgets/date_to_string.dart';

class MatchFetchWidget extends StatefulWidget {
  const MatchFetchWidget(
      {Key? key, required this.matchName, required this.organizerId, required this.color, required this.size})
      : super(key: key);
  final String matchName, organizerId;
  final Color color;
  final double size;

  @override
  _MatchFetchWidgetState createState() => _MatchFetchWidgetState();
}

class _MatchFetchWidgetState extends State<MatchFetchWidget> {
  List<QueryDocumentSnapshot> matches = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection(widget.matchName)
        .orderBy("date")
        .where("uid", isEqualTo: widget.organizerId)
        .snapshots()
        .listen((event) {
      matches = event.docs;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return matches.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.matchName,
                  style: TextStyle(color: widget.color, fontSize: widget.size, decoration: TextDecoration.overline),
                ),
                const SizedBox(height: 5),
                ...matches.map((e) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.09,
                    child: Card(
                      child: ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            e["name"],
                            style: TextStyle(fontSize: widget.size - 1, color: Colors.blue),
                          ),
                          subtitle: Text(DateToString().dateToString(e["date"].toDate())),
                          trailing: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => ContestDetails(
                                              uid: e.id,
                                              matchType: widget.matchName,
                                            ))));
                              },
                              child: const Icon(Icons.open_in_new))),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
  }
}
