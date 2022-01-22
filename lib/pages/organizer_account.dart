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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                  child: Text("Upload Banner (width:height = 4:1)"),
                ),
                const SizedBox(height: 5),
                Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width,
                    child: context.watch<OrganizerModel>().bannerurl != null
                        ? Image.network(context.watch<OrganizerModel>().bannerurl!)
                        :
                        // image widget to come here
                        const ImageWidget()),

                const SizedBox(height: 5),

                // preview button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: // navigate to preview pane
                        () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PreviewPane()));
                    },
                    child: const Text(
                      "Preview",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                    ),
                  ),
                ),

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
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // upload image, update state
      onTap: () {},
      child: Container(
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1.5)),
          alignment: Alignment.center,
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          )),
    );
  }
}
