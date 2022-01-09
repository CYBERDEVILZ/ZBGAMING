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
          // context.read<UserModel>().setuid(auth.currentUser!.uid);
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
        label: Text("Email Address"),
      ),
    );

    // Password Entry
    Widget passwdEntry = TextFormField(
      controller: passwd,
      obscureText: true,
      textInputAction: TextInputAction.done,
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
        label: Text("Password"),
      ),
    );

    // --------------- Return is Here --------------- //
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Column(
        children: [
          // image for login
          const Placeholder(),

          const SizedBox(height: 20),

          const Text(
            "Login To Fight",
            style: TextStyle(),
            textScaleFactor: 2,
          ),

          const SizedBox(height: 5),

          const Text(
            "The Most Competitive Gaming Platform Ever",
            style: TextStyle(),
            textScaleFactor: 0.9,
          ),

          const SizedBox(height: 10),

          // Email Entry
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: emailEntry),

          // Password Entry
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: passwdEntry),

          const SizedBox(height: 20),

          // Login Button
          ElevatedButton(
            onPressed: () {
              validate();
            },
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Login",
                    style: TextStyle(fontSize: 15),
                  ),
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0), fixedSize: MaterialStateProperty.all(const Size(150, 50))),
          ),

          const SizedBox(height: 10),

          // forgot password feature
          const Text("Forgot Password", style: TextStyle(color: Colors.blue)),

          const SizedBox(height: 5),

          // signup feature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                // signup navigation
                onTap: () {},
                child: const Text(
                  "Create one",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, decoration: TextDecoration.underline),
                ),
              )
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    )));
  }
}
