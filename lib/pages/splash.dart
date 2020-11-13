import 'dart:async';

import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/navigator-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Identity identity = getIt<Identity>();

  @override
  void initState() {
    scheduleMicrotask(() {
      identity.hasAuthentication().then((value) {
        if (value) {
          goToStart(context);
        } else {
          Navigator.pushReplacementNamed(context, signInRoute);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 247, 226, 141),
      ),
      child: Center(child: Image(image: AssetImage('assets/splash.png'))),
    ));
  }
}
