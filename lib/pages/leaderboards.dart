import 'package:flutter/material.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  AppBar appBar = AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text(
      "Leaderboard",
      style: TextStyle(fontWeight: FontWeight.w300),
    ),
    centerTitle: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Column(children: [
        // deep blue gradient container
        Container(
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
                            TextSpan(text: "st", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15))
                          ]),
                    ),
                  ),
                  // IMAGE OF THE TOPPER
                  const Expanded(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/csgo.jpg"),
                    ),
                  ),
                  // POINTS OF THE TOPPER
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: RichText(
                      text: const TextSpan(
                          text: "20000",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: "pts", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15))
                          ]),
                    ),
                  )
                ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "Cyberdevilz",
                  style: TextStyle(fontSize: 20, color: Colors.white),
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

        // leaderboard body
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              CustomListTileForLeaderboard(
                  name: "haahahahalskjfljflksdjflksjflskjflsjldfkjsdlkfjslkdjf",
                  imageUrl: "lskdjfs",
                  points: 12345,
                  rank: 2),
              CustomListTileForLeaderboard(name: "jldfkjsdlkfjslkdjf", imageUrl: "lskdjfs", points: 200395, rank: 50),
            ],
          ),
        )
      ]),
    );
  }
}

// custom list tile for leaderboard
class CustomListTileForLeaderboard extends StatelessWidget {
  const CustomListTileForLeaderboard(
      {Key? key, required this.name, required this.imageUrl, required this.points, required this.rank})
      : super(key: key);
  final String name;
  final String imageUrl;
  final int points;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/csgo.jpg"),
              radius: 28,
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
    );
  }
}
