import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/pages/match_start.dart';
import 'package:zbgaming/widgets/date_to_string.dart';

class UpcomingMatch extends StatelessWidget {
  const UpcomingMatch(
      {Key? key, required this.snapshot, required this.matchType})
      : super(key: key);
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final String matchType;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      color: Colors.blueGrey[100],
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: snapshot.data!.docs.isEmpty
              ? const [
                  Text(
                    "No matches found",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  )
                ]
              : snapshot.data!.docs
                  .map((DocumentSnapshot e) => Card(
                        child: ListTile(
                            title: Text(e["name"]),
                            subtitle: Text(DateToString()
                                .dateToString(e["date"].toDate())),
                            trailing: ElevatedButton(
                              // write code for starting the match
                              child: const Text("show"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MatchStart(
                                            matchType: matchType,
                                            matchuid: e.id)));
                              },
                            )),
                      ))
                  .toList()),
    );
  }
}
