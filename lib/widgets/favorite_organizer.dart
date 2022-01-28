import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/not_signed_in.dart';

class FavoriteOrganizers extends StatelessWidget {
  const FavoriteOrganizers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser?.uid == null ? const NotSignedIn() : Container();
  }
}
