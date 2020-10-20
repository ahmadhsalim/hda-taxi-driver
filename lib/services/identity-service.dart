
import 'dart:convert';

import 'package:hda_app/models/user.dart';
import 'package:hda_app/resources/user-resource.dart';
import 'package:hda_app/routes/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Identity {

  FlutterSecureStorage storage = FlutterSecureStorage();

  User _user;

  bool isAuthenticated() {
    return _user != null;
  }

  authenticateJwt(String jwt) async {
    Map<String, dynamic> value = json.decode(
      ascii.decode(
        base64.decode(base64.normalize(jwt.split(".")[1]))
      )
    );

    _user = User.fromJson(value);
    _user.token = jwt;
    storage.write(key: "user", value: _user.toString());
  }

  Future getCurrentUser(List<String> include) async {
    UserResource resource = UserResource();

    var value = await resource.current(include);

    return User.fromJson(value);
  }

  User getUser() {
    return _user;
  }

  String getToken() {
    return _user.token;
  }

  logout(context) {
    _user= null;
    storage.delete(key: "user");
    Navigator.pushReplacementNamed(context, signInRoute);
  }
}