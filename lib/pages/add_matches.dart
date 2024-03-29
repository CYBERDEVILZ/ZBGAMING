import 'package:flutter/material.dart';
import 'package:zbgaming/pages/create_match.dart';

class AddMatches extends StatelessWidget {
  const AddMatches({Key? key, required this.eligible}) : super(key: key);
  final bool eligible;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Choose Game"),
          centerTitle: true,
        ),
        body: TournamentList(eligible: eligible),
      ),
    );
  }
}

class TournamentList extends StatelessWidget {
  const TournamentList({Key? key, required this.eligible}) : super(key: key);
  final bool eligible;

  @override
  Widget build(BuildContext context) {
    // array containing multiple tiles
    final List<Widget> list = [
      // Tile(
      //     img: "assets/images/csgo.jpg",
      //     title: "Counter Strike: Global Offensive",
      //     ontap: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>  CreateMatch(
      //                     matchType: "csgo",
      //                     eligible: eligible,
      //                   )));
      //     }),
      Tile(
          img: "assets/images/freefire.jpg",
          title: "Garena Free Fire",
          ontap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateMatch(
                          matchType: "freefire",
                          eligible: eligible,
                        )));
          }),
      Tile(
          img: "assets/images/pubg.jpg",
          title: "Battlegrounds Mobile India",
          ontap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateMatch(
                          matchType: "pubg",
                          eligible: eligible,
                        )));
          }),
      // Tile(
      //     img: "assets/images/valo.jpg",
      //     title: "Valorant",
      //     ontap: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) =>  CreateMatch(
      //                     matchType: "valo",
      //                     eligible: eligible,
      //                   )));
      //     }),
    ];

    return ListView.builder(
      itemBuilder: (context, index) => list[index],
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}

// tile blueprint
class Tile extends StatelessWidget {
  const Tile({Key? key, required this.img, required this.title, required this.ontap}) : super(key: key);
  final String img;
  final String title;
  final VoidCallback ontap;
  final Widget dropIcon = const Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
      child: GestureDetector(
        onTap: ontap,
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: ClipRRect(
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 150,
                height: 100,
                margin: const EdgeInsets.only(right: 15),
              ),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start)),
              Container(
                child: dropIcon,
                margin: const EdgeInsets.all(5),
              )
            ],
          ),
          height: 100,
        ),
      ),
    );
  }
}
