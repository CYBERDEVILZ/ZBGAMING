import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/pages/show_user_account.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  // variables
  bool isLoading = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> leaderboardValue = [];
  bool notEnoughDetails = true;
  String? leaderName;
  String? leaderImageURL;
  int? leaderPoints;
  Blob? leaderHash;

  // functions
  void fetchData() async {
    // STREAM
    FirebaseFirestore.instance
        .collection("userinfo")
        .orderBy("level", descending: true)
        .limit(50)
        .snapshots()
        .listen((value) {
      leaderboardValue = value.docs;
      if (leaderboardValue.length >= 2) {
        notEnoughDetails = false;
        leaderName = leaderboardValue[0]["username"];
        leaderPoints = leaderboardValue[0]["level"];
        leaderImageURL = leaderboardValue[0]["imageurl"];
        leaderHash = leaderboardValue[0]["hashedID"];
        setState(() {});
      }
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    setState(() {});
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    int index = 1;
    // appbar widget
    AppBar appBar = AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: notEnoughDetails ? const Color(0xff302b63) : Colors.white,
      elevation: 0,
      title: const Text(
        "Leaderboard",
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF302B63)))
          : notEnoughDetails
              ?
              // not enough details dog image
              Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/dog.png"),
                      const Text(
                        "Not Enough Data",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                )
              : Column(children: [
                  // deep blue gradient container
                  GestureDetector(
                    onTap: leaderHash == null
                        ? null
                        : () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ShowUserAccount(hashedId: leaderHash!)));
                          },
                    child: Container(
                      height: 300,
                      padding: EdgeInsets.only(top: appBar.preferredSize.height * 2),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, spreadRadius: 0, blurRadius: 7)],
                        gradient: LinearGradient(
                          colors: <Color>[Color(0xff0f0c29), Color(0xff302b63), Color(0xff24243e)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Row containing 1st rank, image and points
                          Expanded(
                            child: Row(children: [
                              // RANK OF THE TOPPER
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                alignment: Alignment.center,
                                child: RichText(
                                  text: const TextSpan(
                                      text: "1",
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: "st", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15))
                                      ]),
                                ),
                              ),
                              // IMAGE OF THE TOPPER
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: leaderImageURL == null
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color(0xff302b63),
                                        child: Icon(
                                          Icons.account_circle,
                                          size: 100,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: const Color(0xff302b63),
                                        foregroundImage: NetworkImage(leaderImageURL!),
                                      ),
                              )),
                              // POINTS OF THE TOPPER
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: RichText(
                                  text: TextSpan(
                                      text: "$leaderPoints",
                                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      children: const [
                                        TextSpan(
                                            text: "pts", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15))
                                      ]),
                                ),
                              )
                            ]),
                          ),

                          // Name of the topper
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              "$leaderName",
                              style: const TextStyle(fontSize: 20, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: appBar.preferredSize.height / 2,
                          )
                        ],
                      ),
                    ),
                  ),

                  // leaderboard body
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: leaderboardValue.sublist(1).map((e) {
                        index++;
                        return CustomListTileForLeaderboard(
                          name: e["username"],
                          imageUrl: e["imageurl"],
                          points: e["level"],
                          rank: index,
                          hashedId: e["hashedID"],
                        );
                      }).toList(),
                    ),
                  )
                ]),
    );
  }
}

// custom list tile for leaderboard
class CustomListTileForLeaderboard extends StatelessWidget {
  const CustomListTileForLeaderboard(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.points,
      required this.rank,
      required this.hashedId})
      : super(key: key);
  final String name;
  final String? imageUrl;
  final int points;
  final int rank;
  final Blob? hashedId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hashedId == null
          ? null
          : () {
              print("clicked");
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowUserAccount(hashedId: hashedId!)));
            },
      child: Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x33302b63)))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              constraints: const BoxConstraints(minWidth: 23, maxWidth: 23),
              child: Text(
                "$rank",
                style: const TextStyle(color: Color(0xff24243e), fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 15),
            CircleAvatar(
              backgroundColor: const Color(0xff24243e),
              radius: 32,
              child: imageUrl == null
                  ? const CircleAvatar(
                      backgroundColor: Color(0xff302b63),
                      child: Icon(
                        Icons.account_circle,
                        size: 56,
                      ),
                      radius: 28,
                    )
                  : CircleAvatar(
                      backgroundColor: const Color(0xff24243e),
                      radius: 32,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff302b63),
                        foregroundImage: NetworkImage(imageUrl!),
                        radius: 28,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              "$points",
              style: const TextStyle(
                fontSize: 27,
                color: Color(0xff24243e),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
