import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/usermodel.dart';

// drawer after login
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: ListView(
          children: [
            DrawerHeader(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(
                        color: Colors.white,
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("assets/images/zbunker-app-banner.png",
                            fit: BoxFit.fitWidth)), // zbunker banner art
                    SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundImage: const AssetImage("assets/images/csgo.jpg"), // image of account
                                foregroundImage: context.watch<UserModel>().imageurl == null
                                    ? const AssetImage("assets/images/csgo.jpg")
                                    : const AssetImage("assets/images/valo.jpg"), // network image of user from database
                                radius: 40,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  context.watch<UserModel>().username!,
                                  style: const TextStyle(fontSize: 20),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ]),
                      ),
                    )
                  ],
                )),
            ListTile(
              onTap: () {}, // leads to registered matches
              leading: const Icon(Icons.flag),
              trailing: const Icon(Icons.arrow_right),
              title: const Text("Registered Matches"),
            ),
            ListTile(
              onTap: () {}, // leads to favorites
              leading: const Icon(Icons.star),
              trailing: const Icon(Icons.arrow_right),
              title: const Text("Favorites"),
            ),
            ListTile(
              onTap: () {}, // leads to match history
              leading: const Icon(Icons.history),
              trailing: const Icon(Icons.arrow_right),
              title: const Text("History"),
            ),
            ListTile(
              onTap: () {}, // leads to my account
              leading: const Icon(Icons.account_circle),
              trailing: const Icon(Icons.arrow_right),
              title: const Text("My Account"),
            ),
            ListTile(
              onTap: () {}, // leads to Settings
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_right),
              title: const Text("Settings"),
            ),
            const SizedBox(height: 15),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    context.read<UserModel>().signout();
                  }, // sign out user
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red),
                      overlayColor: MaterialStateProperty.all(Colors.red[100]),
                      side: MaterialStateProperty.all(const BorderSide(color: Colors.red, width: 2))),
                )),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Placeholder(), // zbgaming (copyrighted thing)
              height: 100,
            )
          ],
        ));
  }
}

// drawer before login
class MyLoginDrawer extends StatelessWidget {
  const MyLoginDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        child: ListView(
          children: [
            DrawerHeader(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(color: Colors.green, height: 400, child: const Placeholder() // zbgaming banner art
                        ),
                    Container(
                      color: Colors.red.withOpacity(0),
                      height: 400,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 89), // empty space above login button
                            ElevatedButton(
                              child: const Text("Login"),
                              onPressed: () {}, // login navigation
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  fixedSize: MaterialStateProperty.all(const Size(200, 30))),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                    onTap: () {},
                                    child: GestureDetector(
                                      onTap: () {}, // signup navigation
                                      child: const Text(
                                        "Create one",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            ListTile(
              onTap: () {}, // leads to Settings
              leading: const Icon(Icons.settings),
              trailing: const Icon(Icons.arrow_right),
              title: const Text("Settings"),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Placeholder(), // zbgaming (copyrighted thing)
              height: 100,
            )
          ],
        ));
  }
}
