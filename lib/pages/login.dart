import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/utils/routes.dart';

// Notes for me.
// How to validate a user?
// 1. create a form key
// 2. check the validation for form key when user press submit button
// 3. on successfull validation (defined in each validate property of fields), take action

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // text controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController passwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // validation
    void validate() async {
      isLoading = true;
      setState(() {});
      if (_formKey.currentState!.validate()) {
        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signInWithEmailAndPassword(email: email.text, password: passwd.text).then((value) {
          Navigator.pop(context);
        }).catchError((onError) => /* Write code for error */ null);
      }
      isLoading = false;
      setState(() {});
    }

    // Email Entry
    TextFormField emailEntry = TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (email.text.isEmpty) {
          return "Email field cannot be empty";
        }
        if (!RegExp("^[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+[.][a-zA-Z0-9]+\$").hasMatch(email.text)) {
          return "Invalid Email";
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.mail),
        label: Text(
          "Email Address",
        ),
      ),
    );

    // Password Entry
    TextFormField passwdEntry = TextFormField(
      controller: passwd,
      obscureText: true,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (passwd.text.isEmpty) {
          return "Password field cannot be empty";
        }
        if (passwd.text.length < 6) {
          return "Minimum 6 characters needed";
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.vpn_key),
        label: Text(
          "Password",
          style: TextStyle(),
        ),
      ),
    );

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),

                // image for login
                Stack(children: [
                  SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/images/zglitch.gif",
                        fit: BoxFit.contain,
                        color: Colors.blue,
                      )),
                  Positioned.fill(
                      bottom: 10,
                      child: Align(
                        child: Text(
                          "Got Skills? Get Rewarded.",
                          style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.bottomCenter,
                      )),
                ]),

                const SizedBox(height: 20),

                // Email Entry
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: emailEntry),

                // Password Entry
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: passwdEntry),

                const SizedBox(height: 40),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    validate();
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),
                ),

                const SizedBox(height: 30),

                // forgot password feature
                const Text("Forgot Password", style: TextStyle(color: Colors.blue)),

                const SizedBox(height: 5),

                // signup feature
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      // signup navigation
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.signup);
                      },
                      child: const Text(
                        "Create one",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                Align(
                    child: Image.asset("assets/images/zbunker-app-banner.png"),
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.8)
              ],
            ),
          ))),
    );
  }
}
