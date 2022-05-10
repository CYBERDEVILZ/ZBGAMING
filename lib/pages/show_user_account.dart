import 'package:flutter/material.dart';

class ShowUserAccount extends StatelessWidget {
  const ShowUserAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Image.asset(
            "assets/images/zbunker-app-banner-upsidedown-short.png",
            fit: BoxFit.fitWidth,
          ),
          const CircleAvatar(
            maxRadius: 70,
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Card(
              child: Container(
                alignment: Alignment.center,
                height: 500,
                width: double.infinity,
                margin: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 15, right: 15),
                child: Column(
                  children: [
                    const Text("Name"),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 20, left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minHeight: 45),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 105, 164, 212)),
                      width: double.infinity,
                      child: const Text(
                        "CYBERDEVILZ",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const Text("Level"),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 20, left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minHeight: 45),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 70, 124, 168)),
                      width: double.infinity,
                      child: const Text(
                        "VETERAN",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const Text("Contact"),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5, bottom: 20, left: 10, right: 10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minHeight: 45),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 29, 68, 100)),
                      width: double.infinity,
                      child: const Text(
                        "pranavcosmos4@gmail.com",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
