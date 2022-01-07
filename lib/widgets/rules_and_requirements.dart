import 'package:flutter/material.dart';

import 'bullet_text.dart';

class Rules extends StatelessWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> rules = [
      "Log into your account and this is an example of multiline rule to test the resilience of my own bullet text widget heh",
      "Open Game",
      "Enter Code",
      "Begin the Match boii"
    ];

    List<String?> contestDetails = [
      "Tournament is team based",
      "Winner will get all",
      "If there is any discrepancy, ZBunker will look into it dont worry"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How To Join",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.3,
        ),

        const SizedBox(height: 10),

        // rules hardcoded for all games
        ...rules
            .map((e) => BulletText(
                  text: e!,
                ))
            .toList(),

        const SizedBox(height: 20),

        const Text(
          "Contest Details",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.3,
        ),

        const SizedBox(height: 10),

        // contest details
        ...contestDetails
            .map((e) => BulletText(
                  text: e!,
                ))
            .toList(),

        const SizedBox(height: 20),

        const Text(
          "Contact Organizer",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.3,
        ),

        const SizedBox(height: 10),

        // contact details
        const Text("Click on the motherfucking organizer card above to contact idiot")
      ],
    );
  }
}

// Requirements
class Requirements extends StatelessWidget {
  const Requirements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Container(child: const Text(''), color: Colors.lightBlue, width: 5, height: 40),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Login Required For Registration",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              height: 40,
              color: const Color(0xFF222222),
            ))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Container(child: const Text(''), color: Colors.cyan, width: 5, height: 40),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "User Must Be Verified",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              height: 40,
              color: const Color(0xFF222222),
            ))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Row(
          children: [
            Container(child: const Text(''), color: Colors.blue[200], width: 5, height: 40),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "In Game Unique Id Required",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              height: 40,
              color: const Color(0xFF222222),
            ))
          ],
        ),
      ),
    ]);
  }
}
