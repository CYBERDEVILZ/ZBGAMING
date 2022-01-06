import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/organizer_card.dart';
import 'package:zbgaming/widgets/rules.dart';

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
    // contest details widget
    Widget contestDetails = Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(name,
                textAlign: TextAlign.start, textScaleFactor: 2, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Row(children: [
              // date of tournament
              Text(
                "28 December, 2022",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
              ),

              const SizedBox(width: 20),

              // teams registered
              Row(
                children: [
                  Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
                  Text(
                    " $regTeams/",
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                  Text(
                    "$totalTeams",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                  )
                ],
              )
            ]),

            const Divider(height: 50),

            // match format
            const Align(child: Text("Match Format", textScaleFactor: 1.5, style: TextStyle(color: Colors.black))),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 2),
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: team
                              ? [
                                  const Icon(Icons.people_alt, size: 25, color: Colors.purple),
                                  const SizedBox(width: 5),
                                  const Text("Team based\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                ]
                              : const [
                                  Icon(Icons.person, size: 25, color: Colors.purple),
                                  SizedBox(width: 5),
                                  Text("Solo based\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          children: tournament
                              ? [
                                  Icon(Icons.account_tree_sharp, size: 25, color: Colors.blue[800]),
                                  const SizedBox(width: 5),
                                  Text("Tournament\n",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                                ]
                              : [
                                  Icon(Icons.play_arrow, size: 25, color: Colors.blue[800]),
                                  const SizedBox(width: 5),
                                  Text("Single Match\n",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                                ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: skill
                              ? const [
                                  Icon(Icons.flash_on, size: 25, color: Colors.teal),
                                  SizedBox(width: 5),
                                  Text("Min LVL Required",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                ]
                              : const [
                                  Icon(Icons.flash_off, size: 25, color: Colors.teal),
                                  SizedBox(width: 5),
                                  Text("No LVL Required",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Align(
                      child: Column(
                        children: bounty
                            ? const [
                                Icon(Icons.attach_money_outlined, size: 25, color: Colors.red),
                                SizedBox(width: 5),
                                Text("Rewards available",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                              ]
                            : const [
                                Icon(Icons.money_off, size: 25, color: Colors.red),
                                SizedBox(width: 5),
                                Text("No Rewards",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // organizer details
            const Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text("Organized By:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const OrganizerCard(
              imageurl: "assets/images/csgo.jpg",
              rating: 4.0,
              name: "Zbunker Matches and Tournaments",
            ),

            const SizedBox(height: 30),

            // rules
            const Text("Rules", style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.7),
            Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: const Rules(),
            ),

            const SizedBox(height: 30),

            // requirements
            const Text("Requirements", style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.7),
            Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: const Text("Requirements come here..."),
            ),

            const Divider(indent: 50, endIndent: 50, height: 50, thickness: 2, color: Colors.lightBlue),
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contest Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/zbunkerchannelart.png", // change the image to contest banner
              fit: BoxFit.cover,
            ),
          ),

          // contest details
          contestDetails,

          // register button and number of teams
          Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: paid
                        ? const Text(
                            "\u20b9 3000",
                            style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
                          )
                        : const Text(
                            "FREE",
                            style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                    // register button
                    onPressed: () {},
                    child: const Text("Register", textScaleFactor: 1.3),
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                        elevation: MaterialStateProperty.all(0)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
