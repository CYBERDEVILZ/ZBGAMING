import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/usermodel.dart';
import 'package:zbgaming/utils/routes.dart';

// drawer after login
class AfterLoginDrawer extends StatelessWidget {
  const AfterLoginDrawer({Key? key}) : super(key: key);

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
                    // zbunker element straight
                    Container(
                        color: Colors.white,
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset("assets/images/zbunker-app-banner.png", fit: BoxFit.fitWidth)),
                    SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              !(context.watch<UserModel>().imageurl == null)
                                  ? Stack(
                                      children: [
                                        CircleAvatar(backgroundColor: Colors.cyan[700], radius: 45),
                                        Positioned(
                                          top: 5,
                                          left: 5,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.cyan[700],
                                            child: const CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                            foregroundImage: NetworkImage(context.watch<UserModel>().imageurl!),
                                            radius: 40,
                                          ),
                                        )
                                      ],
                                    )
                                  : CircleAvatar(
                                      child: const FittedBox(
                                        fit: BoxFit.cover,
                                        child: Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                          size: 100,
                                        ),
                                      ),
                                      backgroundColor: Colors.cyan[700],
                                      radius: 45),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  context.watch<UserModel>().username == null
                                      ? "null"
                                      : context.watch<UserModel>().username!,
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
              leading: const Icon(Icons.flag, color: Colors.black),
              trailing: const Icon(Icons.arrow_right, color: Colors.black),
              title: const Text(
                "Registered Matches",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {}, // leads to favorites
              leading: const Icon(Icons.star, color: Colors.black),
              trailing: const Icon(Icons.arrow_right, color: Colors.black),
              title: const Text(
                "Favorites",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {}, // leads to match history
              leading: const Icon(Icons.history, color: Colors.black),
              trailing: const Icon(Icons.arrow_right, color: Colors.black),
              title: const Text(
                "History",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {}, // leads to my account
              leading: const Icon(Icons.account_circle, color: Colors.black),
              trailing: const Icon(Icons.arrow_right, color: Colors.black),
              title: const Text(
                "My Account",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {}, // leads to Settings
              leading: const Icon(Icons.settings, color: Colors.black),
              trailing: const Icon(Icons.arrow_right, color: Colors.black),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  // sign out user
                  onPressed: () async {
                    context.read<UserModel>().signout();
                    await FirebaseAuth.instance.signOut();
                  },
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
class BeforeLoginDrawer extends StatelessWidget {
  const BeforeLoginDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // login function
    loginUser() async {
      await Navigator.pushNamed(context, AppRoutes.login);
    }

    return Drawer(
        elevation: 0,
        child: ListView(
          children: [
            DrawerHeader(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    // zbunker element upside down
                    SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset("assets/images/zbunker-app-banner-upsidedown.png", fit: BoxFit.cover),
                    ),

                    Container(
                      color: Colors.red.withOpacity(0),
                      height: 400,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                child: const Text("Login"),
                                onPressed: () {
                                  loginUser();
                                },
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    fixedSize: MaterialStateProperty.all(const Size(200, 30))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, AppRoutes.signup);
                                    }, // signup navigation
                                    child: const Text(
                                      "Create one",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            ListTile(
              onTap: () {}, // leads to Settings
              leading: const Icon(Icons.settings, color: Colors.black),
              trailing: const Icon(Icons.arrow_right, color: Colors.black),
              title: const Text("Settings", style: TextStyle(color: Colors.black)),
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
