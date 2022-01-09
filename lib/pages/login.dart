import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    Widget emailEntry = TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (email.text.isEmpty) {
          return "Email field cannot be empty";
        }
        if (!RegExp("^[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+[.][a-zA-Z0-9]+\$").hasMatch(email.text)) {
          return "Invalid Email";
        }
      },
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        errorStyle: TextStyle(color: Colors.cyan),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan, width: 2)),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.mail, color: Colors.white),
        label: Text(
          "Email Address",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    // Password Entry
    Widget passwdEntry = TextFormField(
      controller: passwd,
      obscureText: true,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (passwd.text.isEmpty) {
          return "Password field cannot be empty";
        }
        if (passwd.text.length < 6) {
          return "Minimum 6 characters needed";
        }
      },
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan, width: 2)),
        errorStyle: TextStyle(color: Colors.cyan),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
        label: Text(
          "Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xff111111),
          body: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // image for login
                  SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/images/zglitch.gif",
                        fit: BoxFit.contain,
                      )),

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
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                        backgroundColor: MaterialStateProperty.all(Colors.cyan)),
                  ),

                  const SizedBox(height: 30),

                  // forgot password feature
                  const Text("Forgot Password", style: TextStyle(color: Colors.cyan)),

                  const SizedBox(height: 5),

                  // signup feature
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        // signup navigation
                        onTap: () {},
                        child: const Text(
                          "Create one",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.cyan, decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ))),
    );
  }
}
