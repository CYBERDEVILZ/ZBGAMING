import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';

class SelectWinner extends StatefulWidget {
  const SelectWinner({Key? key, required this.matchType, required this.matchUid}) : super(key: key);
  final String matchType;
  final String matchUid;

  @override
  State<SelectWinner> createState() => _SelectWinnerState();
}

class _SelectWinnerState extends State<SelectWinner> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> data;
  bool isButtonLoading = false;

  @override
  void initState() {
    super.initState();
  }

  String? query;
  @override
  Widget build(BuildContext context) {
    // stream
    data = FirebaseFirestore.instance
        .collection(widget.matchType)
        .doc(widget.matchUid)
        .collection("registeredUsers")
        .where("IGID", isEqualTo: query)
        .snapshots();

    void showDialogBox(String name, String id, Blob hashedID) {
      showDialog(
          context: context,
          builder: ((context) {
            return StatefulBuilder(
                builder: ((context, setState) => AlertDialog(
                      title: const Text(
                        "Confirm",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      content: Text("Are you sure this player is the winner?\n\nUsername: $name\nGame ID: $id\n",
                          textAlign: TextAlign.center),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.blue),
                              overlayColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1)),
                              side: MaterialStateProperty.all(const BorderSide(color: Colors.blue))),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            isButtonLoading = true;
                            setState(() {});
                            try {
                              // fetch user with winner's hashedid
                              QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
                                  .collection("userinfo")
                                  .where("hashedID", isEqualTo: hashedID)
                                  .get();

                              if (data.docs.isEmpty) {
                                Fluttertoast.showToast(msg: "Something went wrong");
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }

                              // fetch tempUid
                              String tempUid = data.docs[0]["tempUid"];

                              // call API
                              await get(Uri.parse(ApiEndpoints.baseUrl +
                                      ApiEndpoints.selectWinner +
                                      "?organizer_uid=${FirebaseAuth.instance.currentUser?.uid}&match_uid=${widget.matchUid}&match_type=${widget.matchType}&winner_uid=" +
                                      Uri.encodeComponent(tempUid)))
                                  .then((value) {
                                if (value.statusCode != 200) {
                                  Fluttertoast.showToast(msg: "Server side error");
                                  isButtonLoading = false;
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                                if (value.body.contains("Failed")) {
                                  Fluttertoast.showToast(msg: value.body);
                                  isButtonLoading = false;
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(msg: "success");
                                  isButtonLoading = false;
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              }).catchError((onError) {
                                Fluttertoast.showToast(msg: "Something went wrong :(");
                                isButtonLoading = false;
                                setState(() {});
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                              isButtonLoading = false;
                              if (mounted) setState(() {});
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Something went wrong");
                              isButtonLoading = false;
                              setState(() {});
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Confirm"),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                          ),
                        )
                      ],
                    )));
          }));
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select the winner"),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const SizedBox(height: 10),
              // searchbox
              TextFormField(
                onChanged: (value) {
                  value == "" ? query = null : query = value;
                  setState(() {});
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: const Text("Search using Game ID"),
                    suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () {})),
              ),

              const SizedBox(height: 30),
              // stream builder
              StreamBuilder(
                  stream: data,
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      Fluttertoast.showToast(msg: "Some error occurred");
                      return const Text("No data to show");
                    }
                    if (snapshot.hasData) {
                      return Column(children: [
                        ...snapshot.data!.docs.map((e) {
                          return Card(
                            shadowColor: Colors.blue,
                            child: ListTile(
                              title: Text(e["username"]),
                              subtitle: Text("Game ID: ${e['IGID']}"),
                              trailing: OutlinedButton(
                                child: const Text("Winner"),
                                onPressed: () {
                                  showDialogBox(e["username"], e["IGID"], e["hashedID"]);
                                },
                              ),
                            ),
                          );
                        }).toList()
                      ]);
                    } else {
                      return const Text("No data to show");
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }
}
