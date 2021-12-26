import 'package:flutter/material.dart';

class HomePageList extends StatelessWidget {
  const HomePageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

// array containing multiple tiles
List<Widget> list = [
  Tile(img: "assets/images/csgo.jpg", title: "Counter Strike: Global Offensive", ontap: () {}),
  Tile(img: "assets/images/freefire.png", title: "Garena Free Fire", ontap: () {}),
  Tile(img: "assets/images/pubg.png", title: "PUBG New State", ontap: () {}),
  Tile(img: "assets/images/valo.jpg", title: "Valorant", ontap: () {}),
];
