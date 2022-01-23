import 'package:flutter/material.dart';

class OrganizerModel with ChangeNotifier {
  String? _uid;
  String? _imageurl;
  String? _username;
  String? _email;
  String? _bannerurl;

  String? get uid => _uid;
  String? get imageurl => _imageurl;
  String? get username => _username;
  String? get email => _email;
  String? get bannerurl => _bannerurl;

  void setemail(String? email) {
    _email = email;
    notifyListeners();
  }

  void setbannerurl(String? bannerurl) {
    _bannerurl = bannerurl;
    notifyListeners();
  }

  void setuid(String? id) {
    _uid = id;
    notifyListeners();
  }

  void setimageurl(String? imageurl) {
    _imageurl = imageurl;
    notifyListeners();
  }

  void setusername(String? username) {
    _username = username;
    notifyListeners();
  }

  void signout() {
    _uid = null;
    _imageurl = null;
    _username = null;
    notifyListeners();
  }
}
