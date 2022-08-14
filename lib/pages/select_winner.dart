import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SelectWinner extends StatefulWidget {
  const SelectWinner({Key? key, required this.matchType, required this.matchUid}) : super(key: key);
  final String matchType;
  final String matchUid;

  @override
  State<SelectWinner> createState() => _SelectWinnerState();
}

class _SelectWinnerState extends State<SelectWinner> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> data;

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
            return AlertDialog(
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
                      }
                      String id = data.docs[0].id;

                      int amount = 0;
                      await FirebaseFirestore.instance
                          .collection(widget.matchType)
                          .doc(widget.matchUid)
                          .get()
                          .then((value) {
                        int registered = value["reg"];
                        int fee = value["fee"];
                        if (fee == 1) {
                          amount = registered * 60;
                        } else if (fee == 2) {
                          amount = registered * 300;
                        } else if (fee == 3) {
                          amount = registered * 600;
                        } else if (fee == 4) {
                          amount = registered * 3000;
                        }
                      });

                      // INFORMATION DISCLOSURE VULNERABILITY HERE!!! update status to "won"
                      await FirebaseFirestore.instance
                          .collection("userinfo")
                          .doc(id)
                          .collection("history")
                          .doc(widget.matchUid)
                          .update({"won": 1, "amount": amount});

                      // update the same at contest detail page
                      await FirebaseFirestore.instance
                          .collection(widget.matchType)
                          .doc(widget.matchUid)
                          .update({"winnerhash": hashedID});

                      Navigator.pop(context);
                      Navigator.pop(context, id);
                    } catch (e) {
                      Fluttertoast.showToast(msg: "Something went wrong");
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
            );
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
