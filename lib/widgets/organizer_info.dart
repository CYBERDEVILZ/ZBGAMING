import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/match_fetch_widget.dart';
import 'package:zbgaming/widgets/star_builder.dart';

class OrganizerInfo extends StatefulWidget {
  const OrganizerInfo({Key? key, required this.organizerId}) : super(key: key);
  final String organizerId;

  @override
  _OrganizerState createState() => _OrganizerState();
}

class _OrganizerState extends State<OrganizerInfo> {
  bool isLoading = false;
  String? bannerurl;
  String? imageurl;
  String? name;
  String? email;
  bool? special;
  num? rating;
  num? amountGiven;

  void fetchOrganizerData() async {
    isLoading = true;
    setState(() {});
    final FirebaseFirestore _storeInstance = FirebaseFirestore.instance;
    await _storeInstance.collection("organizer").doc(widget.organizerId).get().then((value) {
      try {
        bannerurl = value["bannerurl"];
      } catch (e) {
        bannerurl = null;
      }
      try {
        imageurl = value["imageurl"];
      } catch (e) {
        imageurl = null;
      }
      name = value["username"];
      email = value["email"];
      special = value["special"];
      try {
        int? totalRating = value["total_rating"];
        int? totalReviews = value["total_reviews"];
        rating = totalRating! / totalReviews!;
      } catch (e) {
        rating = 0;
      }
      amountGiven = value["amountGiven"];
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchOrganizerData();
  }

  @override
  Widget build(BuildContext context) {
    //Rating Widget
    Widget ratingWidget = rating == null
        ? Container(margin: const EdgeInsets.only(left: 10 + 125 + 5), child: const Text("Rating: error"))
        : Container(
            margin: const EdgeInsets.only(left: 10 + 125 + 5),
            child: StarBuilder(
              star: rating!,
              starColor: Colors.blue,
              size: 25,
              rowAlignment: MainAxisAlignment.start,
            ));

    // Prize Widget
    Widget totalPrizeGiven = Container(
        margin: const EdgeInsets.only(left: 10 + 125 + 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                  text: "Prizes",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(text: "Awarded:", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w200))
                  ]),
            ),
            Text(
              "\u20B9$amountGiven",
              style: const TextStyle(color: Colors.blue),
            )
          ],
        ));

    // Name Widget
    Widget nameWidget = Text(
      name == null ? "null" : name!,
      style: const TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.w600),
    );

    // Email Widget
    Widget emailWidget = Text(
      email == null ? "null" : email!,
      style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
    );

    // --------------- Return is Here --------------- //
    return Scaffold(
      body: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: Column(children: const [SizedBox(height: 50), Center(child: CircularProgressIndicator())]))
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Banner(getBannerUrl: bannerurl, getImageUrl: imageurl),
                          ratingWidget,
                          const SizedBox(height: 20),
                          totalPrizeGiven,
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                nameWidget,
                                emailWidget,
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          UpcomingMatches(organizerId: widget.organizerId)
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }
}

// Banner for Organizer
class Banner extends StatelessWidget {
  const Banner({Key? key, required this.getBannerUrl, required this.getImageUrl}) : super(key: key);
  final String? getBannerUrl;
  final String? getImageUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      // background banner
      Container(
        height: 125,
        width: MediaQuery.of(context).size.width,
        decoration:
            const BoxDecoration(color: Colors.blue, border: Border(bottom: BorderSide(color: Colors.blue, width: 5))),
        child: getBannerUrl != null
            ? Image.network(
                getBannerUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, obj, s) => const Text("error"),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.white,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null),
                  );
                },
              )
            : null,
      ),

      // profile pic block
      Positioned(
        bottom: -125 / 1.5,
        left: 10,
        child: Container(
          height: 125,
          width: 125,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 5),
          ),
          child: getImageUrl != null
              ? Image.network(
                  getImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, obj, s) => const Text("error"),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                          color: Colors.blue,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null),
                    );
                  },
                )
              : null,
        ),
      )
    ]);
  }
}

// Upcoming Matches
class UpcomingMatches extends StatefulWidget {
  const UpcomingMatches({Key? key, required this.organizerId}) : super(key: key);
  final String organizerId;

  @override
  _UpcomingMatchesState createState() => _UpcomingMatchesState();
}

class _UpcomingMatchesState extends State<UpcomingMatches> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text("Upcoming Tournaments",
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w200)),
        ]),
        MatchFetchWidget(matchName: "csgo", organizerId: widget.organizerId, color: Colors.white, size: 17),
        MatchFetchWidget(matchName: "valorant", organizerId: widget.organizerId, color: Colors.white, size: 17),
        MatchFetchWidget(matchName: "pubg", organizerId: widget.organizerId, color: Colors.white, size: 17),
        MatchFetchWidget(matchName: "freefire", organizerId: widget.organizerId, color: Colors.white, size: 17),
      ]),
    );
  }
}
