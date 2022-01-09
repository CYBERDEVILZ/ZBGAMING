import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? _uid;
  String? _imageurl;
  String? _username;

  String? get uid => _uid;
  String? get imageurl => _imageurl;
  String? get username => _username;

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
