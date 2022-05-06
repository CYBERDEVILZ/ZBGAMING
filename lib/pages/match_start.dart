import 'package:flutter/material.dart';
import 'package:zbgaming/pages/registered_users.dart';

class MatchStart extends StatelessWidget {
  const MatchStart({Key? key, required this.matchType, required this.matchuid})
      : super(key: key);

  final String matchType;
  final String matchuid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(children: [
          ListTile(
            title: const Text("Users Registered"),
            trailing: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisteredUsers(
                              matchType: matchType,
                              matchuid: matchuid,
                            )));
              },
              child: const Icon(Icons.open_in_new),
            ),
          )
        ]),
      ),
    );
  }
}
