import 'dart:async';

import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/services/firebase-messaging-service.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/navigator-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:hda_driver/services/socket-service.dart';
import 'package:hda_driver/styles/MainTheme.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Identity identity = getIt<Identity>();
  FirebaseMessagingService firebase = FirebaseMessagingService();
  SocketService socket = getIt<SocketService>();

  @override
  void initState() {
    scheduleMicrotask(() async {
      await firebase.initialize();

      identity.hasAuthentication().then((value) async {
        if (value) {
          await socket.initialize();
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
        color: MainTheme.primaryColour,
      ),
      child: Center(
          // child: Image(image: AssetImage('assets/splash.png')),
          ),
    ));
  }
}
