import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/vehicle-type-resource.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:hda_driver/styles/MainTheme.dart';
import 'package:hda_driver/widgets/ob-button.dart';
import 'package:hda_driver/widgets/obinov-map.dart';
import 'package:intl/intl.dart';

class BookPage extends StatefulWidget {
  final Trip trip;
  BookPage({Key key, this.trip}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState(trip: trip);
}

class _BookPageState extends State<BookPage> {
  Trip trip;

  static const int BOOKING_INFO_STATE = 0;
  static const int BOOKING_PROGRESS_STATE = 1;
  static const int BOOKING_NOTFOUND_STATE = 2;

  int pageState = BOOKING_INFO_STATE;

  final _key = GlobalKey<ScaffoldState>();
  Key _mapKey = UniqueKey();
  final Identity identity = getIt<Identity>();
  final VehicleTypeResource vehicleTypeResource = VehicleTypeResource();
  final NumberFormat nf = NumberFormat.currency(name: 'MVR');

  _BookPageState({this.trip});

  @override
  initState() {
    super.initState();
  }

  Widget buildIconButton(String label, String assetLocation,
      {Function onPressed}) {
    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 14),
        child: Column(
          children: [
            SvgPicture.asset(
              assetLocation,
              width: 32,
              height: 32,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: TextStyle(
                  color: Color(0xFF707070), fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget showFindingDriver() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              backgroundColor: MainTheme.secondaryColour,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 26),
            Center(
              child: SizedBox(
                  height: 25, child: Text('Finding you a nearby driver.')),
            ),
            Center(
              child: SizedBox(
                height: 25,
                child: Text(
                  'Trying again...',
                  style: TextStyle(color: Color(0xFF707070)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 19, left: 16, right: 16, bottom: 16),
              child: ObButton(
                color: Colors.white,
                text: 'Cancel',
                onPressed: () {
                  setState(() {
                    pageState = BOOKING_INFO_STATE;
                  });
                },
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget showBookingInfo() {
    return Column(
      children: [
        Container(
          color: Color(0xFFF7F7F7),
          height: 86,
          child: Center(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/CarBlackSideSilhouette.png',
                    width: 45,
                  )
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.vehicleType.name,
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    nf.format(trip.vehicleType.fare.minimumFare),
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${trip.vehicleType.seats} seat${trip.vehicleType.seats == 1 ? '' : 's'}",
                    style: TextStyle(color: Color(0xFFCFCED2), fontSize: 15),
                  ),
                  Text(
                    '2 min',
                    style: TextStyle(color: Color(0xFFCFCED2), fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildIconButton('Payment', 'assets/wallet.svg',
                      onPressed: () => null),
                  buildIconButton('Schedule', 'assets/schedule.svg',
                      onPressed: () => null),
                  buildIconButton('Luggage', 'assets/luggage.svg',
                      onPressed: () => null),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ObButton(
                  text: 'Book',
                  onPressed: () {
                    setState(() {
                      pageState = BOOKING_NOTFOUND_STATE;
                      // pageState = BOOKING_PROGRESS_STATE;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget showNotFound() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 26),
            Center(
              child:
                  SizedBox(height: 25, child: Text("We're incredibly sorry.")),
            ),
            Center(
              child: SizedBox(
                height: 25,
                child: Text(
                  'Where could they all be? Shall we try again?',
                  style: TextStyle(color: Color(0xFF707070)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 19, left: 16, right: 16, bottom: 16),
              child: ObButton(
                text: 'Try again',
                onPressed: () {
                  setState(() {
                    pageState = BOOKING_PROGRESS_STATE;
                  });
                },
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget showFooter() {
    switch (pageState) {
      case BOOKING_NOTFOUND_STATE:
        return showNotFound();
        break;
      case BOOKING_PROGRESS_STATE:
        return showFindingDriver();
      default:
        return showBookingInfo();
    }
  }

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
                padding: EdgeInsets.only(top: 30),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context)),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 13),
                      child: Column(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: Color(0xFFF7E28D),
                          ),
                          DottedLine(
                            dashLength: 5,
                            dashGapLength: 5,
                            lineThickness: 2,
                            dashColor: Color(0xFFC8C7CC),
                            direction: Axis.vertical,
                            lineLength: 30,
                          ),
                          Icon(
                            Icons.radio_button_checked,
                            color: Color(0xFF3F44AB),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 3),
                        Text(
                          'PICK-UP',
                          style:
                              TextStyle(color: Color(0xFF707070), fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          trip.start.name,
                          style: TextStyle(fontSize: 14),
                        ),
                        Divider(
                          thickness: 1,
                          height: 16,
                          color: Colors.black,
                        ),
                        Text(
                          'DROP-OFF',
                          style:
                              TextStyle(color: Color(0xFF707070), fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          trip.getDropOff().name,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 15),
                      ],
                    )
                  ],
                )),
            Expanded(
              child: ObinovMap(
                key: _mapKey,
                cameraPosition: trip.getDropOffCameraPosition(),
              ),
            ),
            showFooter(),
          ],
        ),
      ),
    );
  }
}
