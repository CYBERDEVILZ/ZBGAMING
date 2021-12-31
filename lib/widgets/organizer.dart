import 'package:flutter/material.dart';

class OrganizerDetails extends StatelessWidget {
  const OrganizerDetails(
      {Key? key,
      required this.imageurl,
      required this.rating,
      required this.name,
      required this.matches,
      required this.prizes})
      : super(key: key);

  final String imageurl;
  final num rating;
  final String name;
  final num matches;
  final num prizes;

  @override
  Widget build(BuildContext context) {
    // function for rating
    Widget starBuilder(num star) {
      int fullStars = star.floor();
      num halfStars = star.toString()[2] == "0" ? 0 : 1;
      List<Widget> stars = [];
      for (int i = 0; i < fullStars; i++) {
        stars.add(const Icon(Icons.star));
      }
      for (int i = 0; i < halfStars; i++) {
        stars.add(const Icon(Icons.star_half));
      }
      return stars.isEmpty
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("No Rating", textScaleFactor: 1.5)])
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [...stars]);
    }

    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(children: const [
              CircleAvatar(radius: 70, foregroundImage: AssetImage("assets/images/pubg.png")), // network image
              Icon(
                Icons.auto_awesome,
                color: Colors.blue,
                size: 30,
              )
            ]),

            const SizedBox(height: 5),

            starBuilder(rating), // rating widget

            const SizedBox(height: 20),

            // tournament name
            const Text(
              "Zbunker Matches and Tournaments",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
            ),

            const Divider(thickness: 2, indent: 20, endIndent: 20, height: 20),

            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.star), title: const Text("Rating: "), trailing: Text("$rating"))),
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.account_tree),
                          title: const Text("Matches Held: "),
                          trailing: Text("$matches"))),
                  Card(
                      child: ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: const Text("Prizes Given: "),
                          trailing: Text("\u20b9 $prizes")))
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {}, // navigate to matches of organizer
              child: const Text(
                "Upcoming Matches",
                textScaleFactor: 1.5,
              ),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50))),
            )
          ],
        ));
  }
}
