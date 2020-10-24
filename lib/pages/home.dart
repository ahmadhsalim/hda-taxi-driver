import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_app/main.dart';
import 'package:hda_app/models/location.dart';
import 'package:hda_app/resources/misc/resource-collection.dart';
import 'package:hda_app/resources/vehicle-type-resource.dart';
import 'package:hda_app/routes/constants.dart';
import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/location-service.dart';
import 'package:hda_app/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:hda_app/services/trip-service.dart';
import 'package:hda_app/widgets/obinov-map.dart';
import 'package:hda_app/widgets/ob-button.dart';
import 'package:overlay_container/overlay_container.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  Key _mapKey = UniqueKey();
  final Identity identity = getIt<Identity>();
  final TripService tripService = getIt<TripService>();
  final VehicleTypeResource vehicleTypeResource = VehicleTypeResource();

  static const OFF_STATE = 0;
  static const START_SELECTION_STATE = 1;
  static const VEHICLE_SELECTION_STATE = 2;
  int pageState = START_SELECTION_STATE;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // routeObserver is the global variable we created before
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
    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() {
    setState(() {
      pageState = START_SELECTION_STATE;
    });
    // Covering route was popped off the navigator.
  }

  @override
  initState() {
    tripService.createTrip();

    LocationService.getCurrentLocation().then((position) async {
      Location location = await LocationService.getLocationAddress(
          LocationService.getCameraPosition(position));
      setState(() {
        _mapKey = UniqueKey();
        tripService.setStart(location);
      });
    });
    super.initState();
  }

  // InputDecoration _buildInputDecoration(String hint, {dark: false}) {
  //   return InputDecoration(
  //       enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide.none,
  //           borderRadius: BorderRadius.all(Radius.circular(6))),
  //       hintText: hint,
  //       labelStyle: TextStyle(color: Color.fromARGB(255, 233, 233, 233)),
  //       hintStyle: TextStyle(color: Color.fromARGB(255, 36, 46, 66)),
  //       focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide.none,
  //           borderRadius: BorderRadius.all(Radius.circular(6))),
  //       fillColor:
  //           dark ? MainTheme.textBackgroundDark : MainTheme.textBackgroundLite,
  //       filled: true);
  // }

  // Widget _buildStartField() {
  //   return Expanded(
  //       child: SizedBox(
  //           height: 50,
  //           child: TextField(
  //             decoration: _buildInputDecoration(""),
  //             controller: startController,
  //           )));
  // }

  // Widget _buildDropOffField() {
  //   return Expanded(
  //       child: SizedBox(
  //           height: 50,
  //           child: TextField(
  //             decoration: _buildInputDecoration("I'm going to...", dark: true),
  //           )));
  // }

  Widget selectStartButton(BuildContext context) {
    return OverlayContainer(
        show: true,
        position: OverlayContainerPosition(
          0,
          107,
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: ObButton(
            text: 'Continue with current location',
            onPressed: () {
              selectVehicle(context);
            },
          ),
        ));
  }

  void selectVehicle(BuildContext context) async {
    setState(() {
      pageState = VEHICLE_SELECTION_STATE;
    });

    try {
      ResourceCollection vehicleTypes = await vehicleTypeResource.onDuty();
      print(vehicleTypes.data);

      await showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext bc) {
            return Container(
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.access_alarm),
                    title: Text('Vehicle'),
                    onTap: () {
                      setState(() {
                        pageState = START_SELECTION_STATE;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_alarm),
                    title: Text('Vehicle'),
                    onTap: () {
                      setState(() {
                        pageState = START_SELECTION_STATE;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print([e, 'some error']);
    }

    setState(() {
      pageState = START_SELECTION_STATE;
    });
    // double height = MediaQuery.of(context).size.height / 2;
    // return OverlayContainer(
    //     show: true,
    //     position: OverlayContainerPosition(
    //       0,
    //       MediaQuery.of(context).size.height,
    //     ),
    //     child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
    //       Container(
    //         height: MediaQuery.of(context).size.height - height,
    //         width: MediaQuery.of(context).size.width,
    //         color: Color(0x35000000),
    //       ),
    //       Container(
    //         color: Colors.white,
    //         width: MediaQuery.of(context).size.width,
    //         height: height,
    //       )
    //     ]));
  }

  Widget getOverlay(BuildContext context) {
    switch (pageState) {
      case START_SELECTION_STATE:
        return selectStartButton(context);
      case VEHICLE_SELECTION_STATE:
        return SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay = getOverlay(context);

    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        color: Color.fromARGB(255, 247, 247, 247),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10),
                color: Colors.white,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, profileRoute),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 5),
                                  blurRadius: 10)
                            ]),
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.all(18),
                        child: Image.asset('assets/Avatar.png'),
                      ),
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MY CURRENT LOCATION',
                          style:
                              TextStyle(color: Color(0xFF707070), fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          tripService.trip.start.name,
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                )),
            Expanded(
                child: ObinovMap(
              key: _mapKey,
              tripService: tripService,
              onLocationChanged: (CameraPosition position) async {
                Location location =
                    await LocationService.getLocationAddress(position);
                setState(() {
                  tripService.setStart(location);
                });
              },
            )),
            overlay,
          ],
        ),
      ),
    );
  }
}
