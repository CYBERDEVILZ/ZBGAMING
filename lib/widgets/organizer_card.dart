import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/star_builder.dart';

class OrganizerCard extends StatelessWidget {
  const OrganizerCard({Key? key, required this.imageurl, required this.rating, required this.name}) : super(key: key);
  final String imageurl;
  final num rating;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage("assets/images/zbunker-app-banner.png"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // network image
          Stack(clipBehavior: Clip.none, children: [
            const Positioned(bottom: -2, right: -2, child: CircleAvatar(radius: 42, backgroundColor: Colors.white)),
            CircleAvatar(radius: 40, foregroundImage: AssetImage(imageurl))
          ]),

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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const StarBuilder(
                    star: 4.5,
                    starColor: Colors.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ),

          // add to fav
          GestureDetector(
            onTap: () {}, // add or remove from fav func
            child: const Icon(
              Icons.star_border,
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }
}
