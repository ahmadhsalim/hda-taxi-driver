import 'dart:ui';

import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  final Identity identity = getIt<Identity>();
  Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Container(
        margin: MediaQuery.of(context).padding,
        color: Color.fromARGB(255, 247, 247, 247),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Row(children: <Widget>[Text('Home Page')])),
          ],
        ),
      ),
    );
  }
}
