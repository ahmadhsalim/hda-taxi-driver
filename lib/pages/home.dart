import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/location-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:hda_driver/services/socket-service.dart';
import 'package:hda_driver/services/trip-service.dart';
import 'package:hda_driver/styles/MainTheme.dart';
import 'package:hda_driver/widgets/animation-box.dart';

enum HomeState { offline, online, accepting, pickUp, onTrip }

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  final Identity identity = getIt<Identity>();
  final SocketService socket = getIt<SocketService>();
  final DriverResource driverResource = DriverResource();
  final TripService tripService = TripService();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition currentPosition = LocationService.defaultPosition;
  Trip trip;
  Driver driver;
  bool onOffLoading = false;

  HomeState state = HomeState.offline;

  @override
  void initState() {
    driver = identity.getDriver();

    if (driver.onDuty) {
      socket.listen(socketListener);
      state = HomeState.online;
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void socketListener(event) {
    var data = Map<String, dynamic>.from(json.decode(event));
    print([data, 'home socketListener']);
    if (data.containsKey('channel') && data['channel'] == 'trip-request') {
      loadTrip(data['tripId']);
    }
  }

  void loadTrip(id) async {
    trip = await tripService.loadTrip(id);
    setState(() {
      state = HomeState.accepting;
    });
  }

  onOffSwitch(bool value) async {
    if (onOffLoading) return;

    setState(() {
      onOffLoading = true;
    });
    try {
      var result;
      if (value) {
        result = await driverResource.online();
        LocationService.getCurrentLocation().then((Position position) {
          setState(() {
            currentPosition = LocationService.getCameraPosition(position);
          });
        });
      } else
        result = await driverResource.offline();

      if (result != null) {
        setState(() {
          driver.onDuty = value;
          if (driver.onDuty)
            state = HomeState.accepting;
          else
            state = HomeState.offline;
        });
      }
    } catch (e) {} finally {
      setState(() {
        onOffLoading = false;
      });
    }
  }

  String getTitle() {
    return state == HomeState.offline ? 'Your Offline' : 'Accepting Jobs';
  }

  Widget displayItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(title,
                  style: TextStyle(
                    fontSize: 24,
                  ))),
          Center(
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 15, color: Color(0xFF707070)),
            ),
          ),
        ],
      ),
    );
  }

  Widget offlineDisplay(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimationBox(),
            Padding(
              padding: const EdgeInsets.only(
                top: 36,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam viverra nunc volutpat, nibh vestibulum, eu ut cras. In felis netus neque vitae.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFAEAEB2), fontSize: 16),
              ),
            ),
          ]),
    );
  }

  Widget onlineDisplay(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: currentPosition,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: true,
      scrollGesturesEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Widget stats() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 89,
            color: Color.fromARGB(255, 247, 247, 247),
            child: displayItem('MVR 60.00', 'Earned Today'),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            displayItem(2.8.toStringAsFixed(1) + '%', 'Acceptance'),
            displayItem(5.4.toStringAsFixed(1) + '%', 'Ratings'),
            displayItem(4.7.toStringAsFixed(1) + '%', 'Cancellation'),
          ]),
        ],
      ),
    );
  }

  Widget incoming() {
    return Container(
      child: Column(
        children: [
          LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(MainTheme.primaryColour),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  image: DecorationImage(
                    image: FileImage(identity.getProfilePhoto()),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 50,
                width: 50,
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (driver == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Scaffold(
      key: _key,
      body: Container(
        margin: MediaQuery.of(context).padding,
        color: Colors.white,
        // color: Color.fromARGB(255, 247, 247, 247),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  left: 16, top: 10, bottom: 10, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 5),
                              blurRadius: 10)
                        ],
                        image: DecorationImage(
                          image: FileImage(identity.getProfilePhoto()),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  // Text(driver.onDuty ? 'Accepting Jobs' : 'Your Offline',
                  Text(getTitle(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  Switch(
                    activeColor: MainTheme.primaryColour,
                    value: driver.onDuty,
                    onChanged: onOffLoading ? null : onOffSwitch,
                  ),
                ],
              ),
            ),
            onOffLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation(Colors.grey[300]),
                  )
                : SizedBox.shrink(),
            Expanded(
                child: state == HomeState.offline
                    ? offlineDisplay(context)
                    // : SizedBox.expand()
                    : onlineDisplay(context)),
            state == HomeState.accepting ? incoming() : stats()
          ],
        ),
      ),
    );
  }
}
