import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_app/models/location.dart';
import 'package:hda_app/styles/MainTheme.dart';

class PickLocation extends StatefulWidget {
  final CameraPosition cameraPosition;

  PickLocation({Key key, @required this.cameraPosition}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(cameraPosition);
}

class _HomePageState extends State<PickLocation> {
  CameraPosition cameraPosition;
  List<Location> savedPlaces = <Location>[
    Location(name: 'FoodOda', latitude: 4.207683, longitude: 73.540503)
  ];

  _HomePageState(this.cameraPosition) : super();

  Completer<GoogleMapController> _controller = Completer();

  InputDecoration _buildInputDecoration(String hint, {dark: false}) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        hintText: hint,
        labelStyle: TextStyle(color: Color.fromARGB(255, 233, 233, 233)),
        hintStyle: TextStyle(color: Color.fromARGB(255, 36, 46, 66)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        fillColor:
            dark ? MainTheme.textBackgroundDark : MainTheme.textBackgroundLite,
        filled: true);
  }

  Widget _buildLocationField() {
    return Expanded(
        child: SizedBox(
            height: 50,
            child: TextField(
              decoration: _buildInputDecoration("Move marker to set location",
                  dark: true),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Pick a location',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 247, 247, 247),
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                // child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.location_on,
                              color: MainTheme.secondaryColour),
                          onPressed: () {},
                        ),
                        _buildLocationField(),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                    SizedBox(height: 11),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: MainTheme.textBackgroundDark,
                    ),
                    SizedBox(height: 11),
                    Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('Saved places',
                            style: TextStyle(
                                color: MainTheme.textBackgroundDisabled))),
                    Divider(
                      thickness: 1,
                      height: 1,
                      color: MainTheme.textBackgroundDark,
                    ),
                    ...savedPlaces.map((Location e) => Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                color: MainTheme.secondaryColour),
                            SizedBox(
                              width: 13,
                            ),
                            Text(e.name)
                          ],
                        )))
                  ],
                )),
            Divider(
              thickness: 1,
              height: 1,
              color: MainTheme.textBackgroundDark,
            ),
            Expanded(
                child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMove: (CameraPosition position) {
                // setState(() {
                cameraPosition = position;
                // });
              },
              onCameraIdle: () {
                print(cameraPosition);
              },
              // markers: markers,
            ))
          ],
        ),
      ),
    );
  }
}
