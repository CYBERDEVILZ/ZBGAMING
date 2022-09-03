import 'package:flutter/material.dart';

import 'bullet_text.dart';

class Rules extends StatelessWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> rules = [
      "Log into your account.",
      "Link this game from My Account section.",
      "Click on the Register button below.",
      "If successful, you will be contacted by the Organizer for further briefing in the Registered Matches section.",
      "You will receive a notification when the organizer starts the match."
    ];

    List<String?> contestDetails = [
      "Rewards (if any) will be dispatched to your Bank Accounts within 48 hours.",
      "If the Organizer resorts to cheating, you can report the Organizer from this page when the match ends.",
      "Our team will begin the investigation when it receives a report. If it turns out to be a false report, then your account will be banned without warning. So report only and only if you think there is surely some foul play going on.",
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
          "Useful Information",
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
        const Text("Click on the above Organizer's Card.")
      ],
    );
  }
}

// Requirements
class Requirements extends StatelessWidget {
  const Requirements({Key? key, required this.paid}) : super(key: key);
  final bool paid;

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
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  paid ? "User's KYC Must Be Verified" : "User's Email Must Be Verified",
                  style: const TextStyle(color: Colors.white),
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
                  "Game Account Must Be Linked",
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
