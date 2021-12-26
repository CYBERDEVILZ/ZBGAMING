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
  const Tile(
      {Key? key, required this.img, required this.title, required this.ontap})
      : super(key: key);
  final Widget img;
  final String title;
  final VoidCallback ontap;
  final Widget dropIcon = const Icon(Icons.keyboard_arrow_right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          child: Row(
            children: [
              Container(
                child: img,
                width: 150,
                margin: const EdgeInsets.only(right: 5),
              ),
              Expanded(
                  child: Container(
                      child: Align(
                        child: Text(title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.center),
                        alignment: Alignment.center,
                      ),
                      color: Colors.grey)),
              Container(
                child: dropIcon,
                margin: const EdgeInsets.all(5),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          color: Colors.green,
          height: 100,
        ),
      ),
    );
  }
}

// array containing multiple tiles
List<Widget> list = [
  Tile(
      img: const Placeholder(),
      title: "Counter Strike: Global Offensive",
      ontap: () {}),
  Tile(img: const Placeholder(), title: "Garena Free Fire", ontap: () {}),
  Tile(img: const Placeholder(), title: "PUBG New State", ontap: () {}),
  Tile(img: const Placeholder(), title: "Valorant", ontap: () {}),
];
