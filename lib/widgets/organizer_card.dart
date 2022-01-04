import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/star_builder.dart';

class OrganizerCard extends StatelessWidget {
  const OrganizerCard({Key? key, required this.imageurl, required this.rating, required this.name}) : super(key: key);
  final String imageurl;
  final num rating;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // network image
          CircleAvatar(radius: 40, foregroundImage: AssetImage(imageurl)),

          // tournament name and rating
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    child: FittedBox(child: StarBuilder(star: rating)),
                    width: 70,
                  )
                ],
              ),
            ),
          ),

          // add to fav
          const Icon(
            Icons.star_border,
          )
        ]),
      ),
    );
  }
}
