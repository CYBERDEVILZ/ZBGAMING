import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/pages/registered_users.dart';
import 'package:zbgaming/utils/apistring.dart';
import 'package:provider/provider.dart';

class MatchStart extends StatefulWidget {
  const MatchStart({Key? key, required this.matchType, required this.matchuid}) : super(key: key);

  final String matchType;
  final String matchuid;

  @override
  State<MatchStart> createState() => _MatchStartState();
}

class _MatchStartState extends State<MatchStart> {
  bool isStartMatchLoading = false;
  bool loading = true;

  // fetching the start match indicator to decide whether to start or stop match
  void fetchStartMatchIndicator() async {
    await FirebaseFirestore.instance.collection(widget.matchType).doc(widget.matchuid).get().then((value) {
      context.read<StartMatchIndicatorNotifier>().setStartMatchIndicator(value["started"]);
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Some error occurred", backgroundColor: Colors.blue);
    });
    loading = false;
    setState(() {});
  }

  // start match logic
  Future<void> startTheMatch() async {
    await get(Uri.parse(
            ApiEndpoints.baseUrl + ApiEndpoints.startMatch + "?muid=${widget.matchuid}&mType=${widget.matchType}"))
        .then((value) {
      if (value.statusCode != 200) {
        Fluttertoast.showToast(msg: "Some error occurred", backgroundColor: Colors.blue);
      } else if (value.body == "Success") {
        Fluttertoast.showToast(msg: "Success", backgroundColor: Colors.blue);
        context.read<StartMatchIndicatorNotifier>().setStartMatchIndicator(1);
      } else {
        Fluttertoast.showToast(msg: value.body, backgroundColor: Colors.blue);
      }
    });
  }

  // stop match logic
  Future<void> stopTheMatch() async {
    await get(Uri.parse(
            ApiEndpoints.baseUrl + ApiEndpoints.stopMatch + "?muid=${widget.matchuid}&mType=${widget.matchType}"))
        .then((value) {
      if (value.statusCode != 200) {
        Fluttertoast.showToast(msg: "Some error occurred", backgroundColor: Colors.blue);
      } else if (value.body == "Success") {
        Fluttertoast.showToast(msg: "Success", backgroundColor: Colors.blue);
        context.read<StartMatchIndicatorNotifier>().setStartMatchIndicator(2);
      } else {
        Fluttertoast.showToast(msg: value.body, backgroundColor: Colors.blue);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStartMatchIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Match Analysis"),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView(children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisteredUsers(
                            matchType: widget.matchType,
                            matchuid: widget.matchuid,
                          )));
            },
            child: const ListTile(
              title: Text("Users Registered"),
              trailing: Icon(Icons.arrow_right),
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                  onPressed: context.watch<StartMatchIndicatorNotifier>().startMatchIndicatorValue == 2
                      ? null
                      : () async {
                          // if match not started
                          if (Provider.of<StartMatchIndicatorNotifier>(context, listen: false)
                                  .startMatchIndicatorValue ==
                              0) {
                            isStartMatchLoading = true;
                            setState(() {});
                            await startTheMatch();
                          }

                          // if match needs to be stopped
                          else if (Provider.of<StartMatchIndicatorNotifier>(context, listen: false)
                                  .startMatchIndicatorValue ==
                              1) {
                            isStartMatchLoading = true;
                            setState(() {});
                            await stopTheMatch();
                          }

                          isStartMatchLoading = false;
                          setState(() {});
                        },
                  child: isStartMatchLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(context.watch<StartMatchIndicatorNotifier>().startMatchIndicatorValue == 0
                          ? "START MATCH"
                          : context.watch<StartMatchIndicatorNotifier>().startMatchIndicatorValue == 1
                              ? "STOP MATCH"
                              : context.watch<StartMatchIndicatorNotifier>().startMatchIndicatorValue == 2
                                  ? "FINISHED"
                                  : "ERROR")),
            ],
          )
        ]),
      ),
    );
  }
}

class StartMatchIndicatorNotifier extends ChangeNotifier {
  int _startMatchIndicator = 3;

  int get startMatchIndicatorValue => _startMatchIndicator;

  void setStartMatchIndicator(int a) {
    _startMatchIndicator = a;
    notifyListeners();
  }
}
