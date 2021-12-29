import 'package:flutter/material.dart';

class TournamentBuilder extends StatelessWidget {
  const TournamentBuilder(
      {Key? key,
      required this.special,
      required this.name,
      required this.team,
      required this.tournament,
      required this.skill,
      required this.bounty})
      : super(key: key);
  final bool special;
  final String name;
  final bool team;
  final bool tournament;
  final bool skill;
  final bool bounty;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Material(
      child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            // blue if special else grey
            color: special ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      height: 180,
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.amber, // give nice color bruh
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textScaleFactor: 1.4,
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: Row(
                                        children: team
                                            ? const [Icon(Icons.people_alt), SizedBox(width: 5), Text("Team based")]
                                            : const [Icon(Icons.person), SizedBox(width: 5), Text("Solo based")],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(bottom: 3),
                                        child: Row(
                                          children: tournament
                                              ? const [
                                                  Icon(Icons.account_tree_sharp),
                                                  SizedBox(width: 5),
                                                  Text("Tournament")
                                                ]
                                              : const [
                                                  Icon(Icons.play_arrow),
                                                  SizedBox(width: 5),
                                                  Text("Single Match")
                                                ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(bottom: 3),
                                        child: Row(
                                          children: skill
                                              ? const [
                                                  Icon(Icons.verified_user),
                                                  SizedBox(width: 5),
                                                  Text("Min LVL Required")
                                                ]
                                              : const [
                                                  Icon(Icons.verified_user),
                                                  SizedBox(width: 5),
                                                  Text("No LVL Required")
                                                ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(bottom: 3),
                                        child: Row(
                                          children: bounty
                                              ? const [
                                                  Icon(Icons.attach_money_outlined),
                                                  SizedBox(width: 5),
                                                  Text("Rewards available")
                                                ]
                                              : const [Icon(Icons.money_off), SizedBox(width: 5), Text("No Rewards")],
                                        )),
                                  ],
                                ),
                              ),
                            )), // info about tournament like lvl required, team or solo, etc
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "28, December, 2022",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.2,
                                ),
                                Row(children: const [
                                  Icon(Icons.people_alt),
                                  Text(
                                    " 23/",
                                    textScaleFactor: 1.2,
                                  ), // number of teams registered
                                  Text(
                                    "50",
                                    textScaleFactor: 1.2, // total teams allowed
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
