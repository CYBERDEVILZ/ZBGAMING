import "package:flutter/material.dart";

class ValidatorSignUp extends StatelessWidget {
  ValidatorSignUp({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  // text editing controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // text fields
    final TextFormField emailField = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Email Address"),
        controller: email,
        validator: (value) {
          if (email.text.isEmpty) {
            return "Email Address cannot be empty";
          }
          if (!RegExp("[^@]+@+[^@][.][^@]+").hasMatch(email.text)) {
            return "Invalid Email Address";
          }
          return null;
        });

    final TextFormField usernameField = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Username"),
        controller: username,
        validator: (value) {
          if (username.text.isEmpty) {
            return "Username cannot be empty";
          }
          return null;
        });

    final TextFormField passwordField = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Password"),
        controller: password,
        validator: (value) {
          if (password.text.isEmpty) {
            return "Password cannot be empty";
          }
          if (password.text.length < 6) {
            return "Password must be atleast 6 characters long";
          }
          return null;
        });
    final TextFormField confirmPasswordField = TextFormField(
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      controller: confirmPassword,
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Confirm Password"),
      validator: (value) {
        if (confirmPassword.text != password.text) {
          return "Passwords don't match";
        }
        return null;
      },
    );

// --------------- Return is Here --------------- //
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(children: [
            const SizedBox(height: 50),
            const Text("Validators SignUp"),
            const SizedBox(height: 20),
            emailField,
            const SizedBox(height: 20),
            usernameField,
            const SizedBox(height: 20),
            passwordField,
            const SizedBox(height: 20),
            confirmPasswordField,
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() == true) {
                    print("hehe");
                  }
                },
                child: const Text("submit"))
          ]),
        ),
      ),
    ));
  }
}
