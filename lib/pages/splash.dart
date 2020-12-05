import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future initializeFirebase() async {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    String token = await firebaseMessaging.getToken();
    assert(token != null);
    setState(() {
      identity.setFirebaseToken(token);
    });
  }

  @override
  void initState() {
    scheduleMicrotask(() async {
      await initializeFirebase();

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
