import 'package:flutter/material.dart';

class ContestDetails extends StatelessWidget {
  const ContestDetails(
      {Key? key,
      required this.special,
      required this.name,
      required this.team,
      required this.tournament,
      required this.skill,
      required this.bounty,
      required this.paid,
      required this.regTeams,
      required this.totalTeams})
      : super(key: key);
  final bool special;
  final String name;
  final bool team;
  final bool tournament;
  final bool skill;
  final bool bounty;
  final bool paid;
  final int regTeams;
  final int totalTeams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contest Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            // contest banner
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Image.asset(
                "assets/images/valo.jpg", // change the image to contest banner
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // contest name
            Text(
              name,
              textAlign: TextAlign.start,
              textScaleFactor: 2,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // scroll view with tabs
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                color: Colors.grey[200],
                height: 500,
                child: Column(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(
                                child: Text("Contest Details", style: TextStyle(color: Colors.black)),
                              ),
                              Tab(
                                child: Text("About Organizer", style: TextStyle(color: Colors.black)),
                              )
                            ],
                          ),
                          SingleChildScrollView(
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 50,
                                  child: const TabBarView(children: [Text("yooo"), Text("hiii")])))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
            Container(height: 50, color: Colors.red)
          ],
        ),
      ),
    );
  }
}
