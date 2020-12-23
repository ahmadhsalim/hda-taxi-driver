import 'dart:convert';
import 'dart:io';

import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/file-resource.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Identity {
  static String driverKey = "driver";
  FlutterSecureStorage storage = FlutterSecureStorage();

  String _firebaseToken;

  Driver _driver;

  bool isAuthenticated() {
    return _driver != null;
  }

  Future<bool> hasAuthentication() async {
    String driver = await storage.read(key: driverKey);

    if (driver == null) {
      _driver = null;
      return false;
    } else {
      Map<String, dynamic> decoded = json.decode(driver);
      _driver = Driver.fromJson(decoded);

      if (_driver.profilePhotoPath != null)
        _driver.profilePhotoFile = File(_driver.profilePhotoPath);

      return true;
    }
  }

  authenticateJwt(String jwt) async {
    Map<String, dynamic> value = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));

    value['token'] = jwt;
    _driver = Driver.fromJson(value);
    _driver = await getCurrentDriver();
    await store(_driver, jwt);
  }

  Future store(Driver driver, String token) async {
    _driver = driver;
    _driver.token = token;

    String encoded = json.encode(_driver.toJson());
    await storage.write(key: driverKey, value: encoded);
  }

  Future<Driver> getCurrentDriver(
      {List<String> include, bool forceAuth = false}) async {
    DriverResource resource = DriverResource();

    Driver driver =
        await resource.current(include: include, firebaseToken: _firebaseToken);
    if (forceAuth) {
      await store(driver, _driver.token);
      return _driver;
    } else {
      return driver;
    }
  }

  Future fetchProfilePhoto() async {
    try {
      final FileResource fileResource = FileResource(getToken());

      String photoPath = await fileResource.fileDownload(
        fileName: getDriver().profilePhoto,
        // onDownloadProgress: (receivedBytes, totalBytes) {
        //   print([receivedBytes, totalBytes]);
        // },
      );
      if (photoPath != null) setProfilePhoto(photoPath);
    } catch (e) {
      print(e);
    }
  }

  void setProfilePhoto(String path) {
    _driver.profilePhotoPath = path;
    _driver.profilePhotoFile = File(path);
    store(_driver, _driver.token);
  }

  File getProfilePhoto() {
    return _driver.profilePhotoFile;
  }

  Driver getDriver() {
    return _driver;
  }

  String getToken() {
    return _driver.token;
  }

  Future logout(context) {
    _driver = null;
    storage.delete(key: driverKey);
    return Navigator.pushNamedAndRemoveUntil(
        context, signInRoute, (Route<dynamic> route) => false);
  }

  void setFirebaseToken(String token) {
    _firebaseToken = token;
    print([_firebaseToken, '_firebaseToken set']);
  }

  String getFirebaseToken() {
    return _firebaseToken;
  }
}
