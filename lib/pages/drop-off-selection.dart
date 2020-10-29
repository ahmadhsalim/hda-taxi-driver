import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_app/main.dart';
import 'package:hda_app/models/location.dart';
import 'package:hda_app/models/trip.dart';
import 'package:hda_app/resources/vehicle-type-resource.dart';
import 'package:hda_app/routes/constants.dart';
import 'package:hda_app/screen-arguments/book-arguments.dart';
import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/location-service.dart';
import 'package:hda_app/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:hda_app/widgets/obinov-map.dart';
import 'package:hda_app/widgets/ob-button.dart';
import 'package:overlay_container/overlay_container.dart';

class DropOffSelectionPage extends StatefulWidget {
  final Trip trip;
  DropOffSelectionPage({Key key, this.trip}) : super(key: key);

  @override
  _DropOffSelectionPageState createState() =>
      _DropOffSelectionPageState(trip: trip);
}

class _DropOffSelectionPageState extends State<DropOffSelectionPage>
    with RouteAware {
  Trip trip;
  final _key = GlobalKey<ScaffoldState>();
  Key _mapKey = UniqueKey();
  final Identity identity = getIt<Identity>();
  final VehicleTypeResource vehicleTypeResource = VehicleTypeResource();

  static const OFF_STATE = 0;
  static const ON_STATE = 1;

  int pageState = ON_STATE;
  // final NumberFormat nf = NumberFormat.currency(name: 'MVR');

  _DropOffSelectionPageState({this.trip});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    setState(() {
      pageState = OFF_STATE;
    });
  }

  @override
  void didPopNext() {
    setState(() {
      pageState = ON_STATE;
    });
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
                      child: Icon(
                        Icons.radio_button_checked,
                        color: Color(0xFF3F44AB),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 3),
                        Text(
                          'DROP-OFF LOCATION',
                          style:
                              TextStyle(color: Color(0xFF707070), fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          trip.getDropOff()?.name ?? '',
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
                selectLocation: true,
                cameraPosition: trip.getStartCameraPosition(),
                onLocationChanged: (CameraPosition position) async {
                  Location location =
                      await LocationService.getLocationAddress(position);
                  setState(() {
                    trip.setDropOff(location);
                  });
                },
              ),
            ),
            pageState == OFF_STATE
                ? SizedBox.shrink()
                : OverlayContainer(
                    show: true,
                    position: OverlayContainerPosition(
                      0,
                      107,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      child: ObButton(
                        text: 'Set drop-off location',
                        onPressed: () {
                          setState(() {
                            pageState = OFF_STATE;
                          });
                          Navigator.pushNamed(
                            context,
                            bookRoute,
                            arguments: BookArguments(trip),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
