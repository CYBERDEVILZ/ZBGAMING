import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? _uid = "sldkjf";
  String? _imageurl = "lskdjf";

  String? get uid => _uid;
  String? get imageurl => _imageurl;

  void setuid(String? id) {
    _uid = id;
    notifyListeners();
  }

  void setimageurl(String? imageurl) {
    _imageurl = imageurl;
    notifyListeners();
  }
}
