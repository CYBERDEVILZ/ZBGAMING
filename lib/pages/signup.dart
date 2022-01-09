import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwdController = TextEditingController();
  final TextEditingController confirmPasswdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // username
    TextFormField username = TextFormField(
      controller: usernameController,
    );

    // email
    TextFormField email = TextFormField(
      controller: emailController,
    );

    // password
    TextFormField password = TextFormField(
      controller: passwdController,
    );

    // confirm password
    TextFormField confirmPassword = TextFormField(
      controller: confirmPasswdController,
    );

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                // image for signup
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/zbunker-app-banner-upsidedown.png"), fit: BoxFit.fitWidth)),
                ),
              ]),

              const SizedBox(height: 20),

              // username
              username,

              const SizedBox(height: 10),

              // email
              email,

              const SizedBox(height: 10),

              // password
              password,

              const SizedBox(height: 10),

              // confirm password
              confirmPassword,

              const SizedBox(height: 10),

              // submit button
              ElevatedButton(onPressed: () {}, child: const Text("Sign Up"))
            ],
          ),
        ),
      ),
    );
  }
}
