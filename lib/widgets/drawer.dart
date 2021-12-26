import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.red,
        elevation: 0,
        child: Material(
          child: DrawerHeader(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  Container(
                      color: Colors.green,
                      height: MediaQuery.of(context).size.height / 4,
                      child:
                          const Placeholder() // use image.asset with fitcover
                      ),
                  Container(
                    color: Colors.red.withOpacity(0),
                    height: MediaQuery.of(context).size.height / 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 8),
                          ElevatedButton(
                            child: const Text("Login"),
                            onPressed: () {}, // login navigation
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(200, 30))),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {},
                                child: GestureDetector(
                                  onTap: () {}, // signup navigation
                                  child: const Text(
                                    "Create one",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
