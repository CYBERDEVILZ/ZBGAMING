import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/date_to_string.dart';

class MatchUpdates extends StatefulWidget {
  const MatchUpdates({Key? key, required this.notificationid}) : super(key: key);
  final Blob notificationid;

  @override
  State<MatchUpdates> createState() => _MatchUpdatesState();
}

class _MatchUpdatesState extends State<MatchUpdates> {
  bool isLoading = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatData;

  @override
  void initState() {
    super.initState();
    chatData = FirebaseFirestore.instance
        .collection("chats")
        .where("notificationId", isEqualTo: widget.notificationid)
        .limit(1)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Match Updates"),
            elevation: 0,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 64.0),
            child: StreamBuilder(
                stream: chatData,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Text("No Data");
                  }
                  try {
                    return ListView(physics: const BouncingScrollPhysics(), children: <Widget>[
                      ...(snapshot.data!.docs.first["chats"]
                          .map((obj) => NotificationBubble(text: obj["message"], date: obj["time"]))
                          .toList())
                    ]);
                  } catch (e) {
                    return const Text("No Updates to Show");
                  }
                }),
          )),
    );
  }
}

class NotificationBubble extends StatelessWidget {
  const NotificationBubble({Key? key, required this.text, required this.date}) : super(key: key);
  final String text;
  final Timestamp date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Organizer",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600, height: 1.3),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateToString().dateToString(date.toDate()),
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    date.toDate().toIso8601String().substring(11, 16),
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
