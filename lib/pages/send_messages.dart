import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';
import 'package:zbgaming/widgets/date_to_string.dart';

class SendMessages extends StatefulWidget {
  const SendMessages({Key? key, required this.notificationid, required this.matchType, required this.matchUid})
      : super(key: key);
  final Blob notificationid;
  final String matchType;
  final String matchUid;

  @override
  State<SendMessages> createState() => _SendMessagesState();
}

class _SendMessagesState extends State<SendMessages> {
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

  GlobalKey formKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Match Updates"),
              elevation: 0,
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
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
                            return CustomScrollView(
                              slivers: [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Column(children: <Widget>[
                                    ...(snapshot.data!.docs.first["chats"]
                                        .map((obj) => NotificationBubble(text: obj["message"], date: obj["time"]))
                                        .toList())
                                  ]),
                                )
                              ],
                            );
                          } catch (e) {
                            return Text("No Updates to Show" + e.toString());
                          }
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: GestureDetector(
                              child: const Icon(Icons.send),
                              onTap: () async {
                                if (messageController.text.isNotEmpty) {
                                  String? docId;
                                  await FirebaseFirestore.instance
                                      .collection("chats")
                                      .where("notificationId", isEqualTo: widget.notificationid)
                                      .get()
                                      .then((value) {
                                    docId = value.docs[0].id;
                                  });
                                  await FirebaseFirestore.instance.collection("chats").doc(docId).update({
                                    "chats": FieldValue.arrayUnion([
                                      {"message": messageController.text, "time": DateTime.now().toLocal()}
                                    ]),
                                  });
                                  messageController.clear();
                                  await get(Uri.parse(ApiEndpoints.baseUrl +
                                      "/api/receivedNotification?muid=${widget.matchUid}&mtype=${widget.matchType}"));
                                }
                              },
                            )),
                      ))
                    ],
                  ),
                )
              ],
            )),
      ),
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
