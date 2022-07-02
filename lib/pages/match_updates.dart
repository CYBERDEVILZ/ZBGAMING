import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchUpdates extends StatefulWidget {
  const MatchUpdates({Key? key, required this.notificationid}) : super(key: key);
  final Blob notificationid;

  @override
  State<MatchUpdates> createState() => _MatchUpdatesState();
}

class _MatchUpdatesState extends State<MatchUpdates> {
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
            child: ListView(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              children: [
                const NotificationBubble(
                  text: "sldkfjlskdjfsdl",
                  date: "3:15 pm",
                ),
                const NotificationBubble(
                  text: "sldkfjlskdjfsdl",
                  date: "3:15 pm",
                ),
                const NotificationBubble(
                  text: "sldkfjlskdjfsdlkjsd\nlaksjdlsdkfjasdfsfsdfsdfksdjfhsdkfhsdkjfhskjfshdkjfhsdkjhsdfkjsdhfkjsdfh",
                  date: "3:00 pm",
                ),
              ],
            ),
          )),
    );
  }
}

class NotificationBubble extends StatelessWidget {
  const NotificationBubble({Key? key, required this.text, required this.date}) : super(key: key);
  final String text;
  final String date;

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
                "Organizer Name",
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
                    date,
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
