// import 'package:flutter/material.dart';
// import 'package:zbgaming/pages/contest_details.dart';

// class OrganizerTournaments extends StatefulWidget {
//   const OrganizerTournaments(
//       {Key? key,
//       required this.special,
//       required this.name,
//       required this.team,
//       required this.tournament,
//       required this.skill,
//       required this.bounty,
//       required this.paid,
//       required this.regTeams,
//       required this.totalTeams})
//       : super(key: key);
//   final bool special;
//   final String name;
//   final bool team;
//   final bool tournament;
//   final bool skill;
//   final bool bounty;
//   final bool paid;
//   final int regTeams;
//   final int totalTeams;

//   @override
//   State<OrganizerTournaments> createState() => _OrganizerTournamentsState();
// }

// class _OrganizerTournamentsState extends State<OrganizerTournaments> {
//   bool _expanded = false;
//   void navigate() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => ContestDetails(
//                 bounty: widget.bounty,
//                 name: widget.name,
//                 paid: widget.paid,
//                 regTeams: widget.regTeams,
//                 skill: widget.skill,
//                 special: widget.special,
//                 team: widget.team,
//                 totalTeams: widget.totalTeams,
//                 tournament: widget.tournament,
//               )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // collapsed card
//     Widget collapsedTournamentCard = Material(
//       key: const Key("key_two"),
//       color: Colors.grey[200], // canvas color
//       child: Container(
//           clipBehavior: Clip.antiAlias,
//           margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//           decoration: BoxDecoration(
//             gradient: widget.special
//                 ? const LinearGradient(
//                     colors: [Colors.blue, Colors.purple], begin: Alignment.topCenter, end: Alignment.bottomCenter)
//                 : null,
//             color: widget.special ? Colors.white : Colors.white, // special then bg image else grey color
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: 110,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         navigate();
//                       }, // navigates to tournament details page
//                       child: Container(
//                           height: 110,
//                           width: MediaQuery.of(context).size.width - 20,
//                           color: Colors.white, // card bg color
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10.0, right: 5, top: 5, bottom: 5),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         widget.name,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(fontWeight: FontWeight.bold),
//                                         textScaleFactor: 1.4,
//                                       ),
//                                     ),
//                                     widget.paid ? const Icon(Icons.paid_outlined, color: Colors.red) : const Text("")
//                                   ],
//                                 ),
//                                 Expanded(
//                                     child: SizedBox(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 8.0),
//                                         child: widget.team
//                                             ? const Icon(Icons.people_alt, size: 20, color: Colors.purple)
//                                             : const Icon(Icons.person, size: 20, color: Colors.purple),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 8.0),
//                                         child: widget.tournament
//                                             ? Icon(Icons.account_tree_sharp, size: 20, color: Colors.blue[800])
//                                             : Icon(Icons.play_arrow, size: 20, color: Colors.blue[800]),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 8.0),
//                                         child: widget.skill
//                                             ? const Icon(Icons.flash_on, size: 20, color: Colors.teal)
//                                             : const Icon(Icons.flash_off, size: 20, color: Colors.teal),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 8.0),
//                                         child: widget.bounty
//                                             ? const Icon(Icons.attach_money_outlined, size: 20, color: Colors.red)
//                                             : const Icon(Icons.money_off, size: 20, color: Colors.red),
//                                       ),
//                                     ],
//                                   ),
//                                 )),
//                                 const Divider(
//                                   height: 5,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "28, December, 2022",
//                                       textScaleFactor: 1.1,
//                                       style:
//                                           TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
//                                     ),
//                                     Row(children: [
//                                       Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
//                                       Text(
//                                         " ${widget.regTeams}/",
//                                         textScaleFactor: 1.1,
//                                         style: TextStyle(color: Colors.black.withOpacity(0.5)),
//                                       ), // number of teams registered
//                                       Text(
//                                         "${widget.totalTeams}",
//                                         textScaleFactor: 1.1, // total teams allowed
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
//                                       )
//                                     ]),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _expanded = true;
//                       setState(() {});
//                     },
//                     child: Container(
//                       color: Colors.white,
//                       child: const Icon(
//                         Icons.arrow_drop_down_sharp,
//                         size: 30,
//                       ),
//                       height: 110,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )),
//     );

//     // expanded card
//     Widget expandedTournamentCard = Material(
//       key: const Key("key_one"),
//       color: Colors.grey[200], // canvas color
//       child: Container(
//           clipBehavior: Clip.antiAlias,
//           margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//           decoration: BoxDecoration(
//             gradient: widget.special
//                 ? const LinearGradient(
//                     colors: [Colors.blue, Colors.purple], begin: Alignment.topCenter, end: Alignment.bottomCenter)
//                 : null,
//             color: widget.special ? Colors.white : Colors.white,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           height: 170,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         navigate();
//                       }, // navigates to respective tournament details page
//                       child: Container(
//                           height: 170,
//                           width: MediaQuery.of(context).size.width - 20,
//                           color: Colors.white, // card bg color
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10.0, right: 5, top: 5, bottom: 5),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         widget.name,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(fontWeight: FontWeight.bold),
//                                         textScaleFactor: 1.4,
//                                       ),
//                                     ),
//                                     widget.paid
//                                         ? const Icon(
//                                             Icons.paid_outlined,
//                                             color: Colors.red,
//                                           )
//                                         : const Text("")
//                                   ],
//                                 ),
//                                 Expanded(
//                                     child: SizedBox(
//                                   width: MediaQuery.of(context).size.width,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(bottom: 5, top: 5),
//                                         child: Row(
//                                           children: widget.team
//                                               ? [
//                                                   const Icon(Icons.people_alt, size: 20, color: Colors.purple),
//                                                   const SizedBox(width: 5),
//                                                   const Text("Team based",
//                                                       style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                           fontSize: 12,
//                                                           color: Colors.purple))
//                                                 ]
//                                               : const [
//                                                   Icon(Icons.person, size: 20, color: Colors.purple),
//                                                   SizedBox(width: 5),
//                                                   Text("Solo based",
//                                                       style: TextStyle(
//                                                           fontWeight: FontWeight.bold,
//                                                           fontSize: 12,
//                                                           color: Colors.purple))
//                                                 ],
//                                         ),
//                                       ),
//                                       Padding(
//                                           padding: const EdgeInsets.only(bottom: 5),
//                                           child: Row(
//                                             children: widget.tournament
//                                                 ? [
//                                                     Icon(Icons.account_tree_sharp, size: 20, color: Colors.blue[800]),
//                                                     const SizedBox(width: 5),
//                                                     Text("Tournament",
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 12,
//                                                             color: Colors.blue[800]))
//                                                   ]
//                                                 : [
//                                                     Icon(Icons.play_arrow, size: 20, color: Colors.blue[800]),
//                                                     const SizedBox(width: 5),
//                                                     Text("Single Match",
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 12,
//                                                             color: Colors.blue[800]))
//                                                   ],
//                                           )),
//                                       Padding(
//                                           padding: const EdgeInsets.only(bottom: 5),
//                                           child: Row(
//                                             children: widget.skill
//                                                 ? const [
//                                                     Icon(Icons.flash_on, size: 20, color: Colors.teal),
//                                                     SizedBox(width: 5),
//                                                     Text("Min LVL Required",
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 12,
//                                                             color: Colors.teal))
//                                                   ]
//                                                 : const [
//                                                     Icon(Icons.flash_off, size: 20, color: Colors.teal),
//                                                     SizedBox(width: 5),
//                                                     Text("No LVL Required",
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 12,
//                                                             color: Colors.teal))
//                                                   ],
//                                           )),
//                                       Padding(
//                                           padding: const EdgeInsets.only(bottom: 5),
//                                           child: Row(
//                                             children: widget.bounty
//                                                 ? const [
//                                                     Icon(Icons.attach_money_outlined, size: 20, color: Colors.red),
//                                                     SizedBox(width: 5),
//                                                     Text("Rewards available",
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 12,
//                                                             color: Colors.red))
//                                                   ]
//                                                 : const [
//                                                     Icon(Icons.money_off, size: 20, color: Colors.red),
//                                                     SizedBox(width: 5),
//                                                     Text("No Rewards",
//                                                         style: TextStyle(
//                                                             fontWeight: FontWeight.bold,
//                                                             fontSize: 12,
//                                                             color: Colors.red))
//                                                   ],
//                                           )),
//                                     ],
//                                   ),
//                                 )),
//                                 const Divider(
//                                   height: 5,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "28 December, 2022",
//                                       textScaleFactor: 1.1,
//                                       style:
//                                           TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
//                                     ),
//                                     Row(children: [
//                                       Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
//                                       Text(
//                                         " ${widget.regTeams}/",
//                                         textScaleFactor: 1.1,
//                                         style: TextStyle(color: Colors.black.withOpacity(0.5)),
//                                       ), // number of teams registered
//                                       Text(
//                                         "${widget.totalTeams}",
//                                         textScaleFactor: 1.1, // total teams allowed
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
//                                       )
//                                     ]),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           )),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       _expanded = false;
//                       setState(() {});
//                     },
//                     child: Container(
//                       color: Colors.white,
//                       child: const Icon(
//                         Icons.arrow_drop_up_sharp,
//                         size: 30,
//                       ),
//                       height: 170,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           )),
//     );

//     return _expanded ? expandedTournamentCard : collapsedTournamentCard;
//   }
// }
