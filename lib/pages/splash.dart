
import 'dart:async';

import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hda_app/routes/constants.dart';

class SplashPage extends StatefulWidget {
  SplashPage({ Key key }): super(key: key);


  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  Identity identity = getIt<Identity>();

  @override
  void initState() {
    scheduleMicrotask(() => {
      if(identity.isAuthenticated()) {
        Navigator.pushReplacementNamed(context, homeRoute),
      }else{
        Navigator.pushReplacementNamed(context, signInRoute),
      }
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
      )
    );
  }
}