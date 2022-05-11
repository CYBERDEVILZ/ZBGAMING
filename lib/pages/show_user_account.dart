import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_colorful_container.dart';

class ShowUserAccount extends StatelessWidget {
  const ShowUserAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue.withOpacity(0.2),
        body: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(MediaQuery.of(context).size.width))),
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              Image.asset(
                "assets/images/zbunker-app-banner-upsidedown-short.png",
                fit: BoxFit.fitWidth,
              ),
              const CircleAvatar(
                maxRadius: 70,
              ),
              const SizedBox(height: 30),
              const ShadowedContainer(
                textWidget: Text(
                  "CYBERDEVILZ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const ShadowedContainer(
                  textWidget: Text(
                "VETERAN",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ))
            ],
          ),
        )),
      ),
    );
  }
}
