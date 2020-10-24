import 'dart:convert';

import 'package:hda_app/models/customer.dart';
import 'package:hda_app/resources/customer-resource.dart';
import 'package:hda_app/routes/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Identity {
  static String customerKey = "customer";
  FlutterSecureStorage storage = FlutterSecureStorage();

  Customer _customer;

  bool isAuthenticated() {
    return _customer != null;
  }

  Future<bool> hasAuthentication() async {
    // await storage.delete(key: customerKey);
    String customer = await storage.read(key: customerKey);

    if (customer == null) {
      _customer = null;
      return false;
    } else {
      Map<String, dynamic> decoded = json.decode(customer);
      _customer = Customer.fromJson(decoded);
      return true;
    }
  }

  authenticateJwt(String jwt) async {
    Map<String, dynamic> value = json.decode(
        ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1]))));

    value['token'] = jwt;
    _customer = Customer.fromJson(value);
    _customer = await getCurrentCustomer();
    _customer.token = jwt;
    String encoded = json.encode(_customer.toJson());
    await storage.write(key: customerKey, value: encoded);
  }

  Future<Customer> getCurrentCustomer({List<String> include}) {
    CustomerResource resource = CustomerResource();

    return resource.current(include: include);
  }

  Customer getCustomer() {
    return _customer;
  }

  String getToken() {
    return _customer.token;
  }

  logout(context) {
    _customer = null;
    storage.delete(key: customerKey);
    Navigator.pushNamedAndRemoveUntil(
        context, signInRoute, (Route<dynamic> route) => false);

    // Navigator.pushReplacementNamed(context, signInRoute);
  }
}
