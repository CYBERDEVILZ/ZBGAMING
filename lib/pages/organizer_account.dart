import 'package:flutter/material.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/organizermodel.dart';
import 'package:zbgaming/pages/organizer_preview_pane.dart';

class OrganizerAccount extends StatefulWidget {
  const OrganizerAccount({Key? key}) : super(key: key);

  @override
  State<OrganizerAccount> createState() => _OrganizerAccountState();
}

class _OrganizerAccountState extends State<OrganizerAccount> {
  @override
  Widget build(BuildContext context) {
    void updateImage() async {}

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("My Account"), elevation: 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(children: [
                  // image
                  context.watch<OrganizerModel>().imageurl == null
                      ? const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 70,
                          child: FittedBox(
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 180,
                            ),
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 70,
                          child: FittedBox(
                            child: Image.network(context.watch<OrganizerModel>().imageurl!),
                          ),
                        ),

                  // edit button
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        // edit the image
                        onTap: () {
                          updateImage();
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Colors.black,
                        ),
                      )),
                ]),
              ),

              const SizedBox(height: 20),

              // Name
              Text(context.watch<OrganizerModel>().username!),

              const SizedBox(height: 30),

              // Upload banner
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Upload Banner (120 x 1920)"),
              ),
              const SizedBox(height: 10),
              Container(
                  color: Colors.grey,
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: context.watch<OrganizerModel>().imageurl != null
                      ? Image.network(context.watch<OrganizerModel>().imageurl!)
                      : const Icon(Icons.image)),
              // preview button
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      // navigate to preview pane
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PreviewPane()));
                      },
                      child: const Text("Preview"))),

              const SizedBox(height: 20),

              // bank information tile
              GestureDetector(
                onTap: () {},
                child: const ListTile(
                  title: Text("Bank Information"),
                  trailing: Icon(Icons.arrow_right),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
