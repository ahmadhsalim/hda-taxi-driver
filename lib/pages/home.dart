import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_app/main.dart';
import 'package:hda_app/models/location.dart';
import 'package:hda_app/models/trip.dart';
import 'package:hda_app/models/vehicle-type.dart';
import 'package:hda_app/resources/misc/resource-collection.dart';
import 'package:hda_app/resources/vehicle-type-resource.dart';
import 'package:hda_app/routes/constants.dart';
import 'package:hda_app/screen-arguments/drop-off-selection-arguments.dart';
import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/location-service.dart';
import 'package:hda_app/services/service-locator.dart';
import 'package:flutter/material.dart';
import 'package:hda_app/widgets/obinov-map.dart';
import 'package:hda_app/widgets/ob-button.dart';
import 'package:intl/intl.dart';
import 'package:overlay_container/overlay_container.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  final _key = GlobalKey<ScaffoldState>();
  Key _mapKey = UniqueKey();
  final Identity identity = getIt<Identity>();
  Trip trip;
  final VehicleTypeResource vehicleTypeResource = VehicleTypeResource();
  final NumberFormat nf = NumberFormat.currency(name: 'MVR');

  static const OFF_STATE = 0;
  static const START_SELECTION_STATE = 1;
  static const VEHICLE_SELECTION_STATE = 2;
  int pageState = START_SELECTION_STATE;
  bool isCurrentLocation = true;

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
      pageState = START_SELECTION_STATE;
    });
  }

  @override
  initState() {
    trip = Trip();
    trip.start = Location(
        name: 'Pick-up',
        latitude: LocationService.defaultPosition.target.latitude,
        longitude: LocationService.defaultPosition.target.longitude,
        type: 'start');

    LocationService.getCurrentLocation().then((position) async {
      Location location = await LocationService.getLocationAddress(
          LocationService.getCameraPosition(position));
      setState(() {
        _mapKey = UniqueKey();
        trip.setStart(location);
        // tripService.setStart(location);
      });
    });
    super.initState();
  }

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
            text: isCurrentLocation
                ? 'Continue with current location'
                : 'Set pick-up location',
            onPressed: () {
              vehicleSelector(context);
            },
          ),
        ));
  }

  void vehicleSelector(BuildContext context) async {
    setState(() {
      pageState = VEHICLE_SELECTION_STATE;
    });

    try {
      ResourceCollection<VehicleType> vehicleTypes = await vehicleTypeResource
          .full(params: {'include': 'fare', 'order': 'id,asc'});
      if (vehicleTypes.data.length == 0) {
        _key.currentState.showSnackBar(SnackBar(
          content: Text(
            'No vehicles available at the moment.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          duration: Duration(seconds: 3),
        ));
      } else {
        vehicleTypes.data.forEach((type) async {
          type.iconWidget = SvgPicture.string(type.icon);
        });
        await showModalBottomSheet(
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext bc) {
              return Container(
                child: Wrap(
                  children: vehicleTypes.data.map((vehicleType) {
                    Color hoverColor = Color(0xFFF7E28D);
                    return Column(
                      children: [
                        ListTile(
                          focusColor: hoverColor,
                          hoverColor: hoverColor,
                          leading: vehicleType.iconWidget,
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  vehicleType.name,
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFF333333)),
                                ),
                                Text(
                                  nf.format(vehicleType.fare.minimumFare),
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFF333333)),
                                ),
                              ]),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${vehicleType.seats} seat${vehicleType.seats == 1 ? '' : 's'}",
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF707070)),
                                ),
                                Text(
                                  vehicleType.onDuty > 0
                                      ? 'Available'
                                      : 'Not available',
                                  style: TextStyle(
                                      fontSize: 15, color: Color(0xFF707070)),
                                ),
                              ]),
                          onTap: vehicleType.onDuty > 0
                              ? () {
                                  setState(() {
                                    trip.vehicleType = vehicleType;
                                    pageState = OFF_STATE;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, dropOffSelectionRoute,
                                      arguments:
                                          DropOffSelectionArguments(trip));
                                }
                              : null,
                        ),
                        Divider(
                          height: 0,
                          thickness: 0,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            });
      }
    } catch (e) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text(
          'Connection error. Try again.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      ));
      print(e);
      setState(() {
        pageState = START_SELECTION_STATE;
      });
    }
  }

  Widget getOverlay(BuildContext context) {
    switch (pageState) {
      case START_SELECTION_STATE:
        return selectStartButton(context);
      // case VEHICLE_SELECTION_STATE:
      //   return SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay = getOverlay(context);

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
                child: Row(
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
                          ],
                        ),
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.all(18),
                        child:
                            SvgPicture.asset('assets/avatar_placeholder.svg'),
                      ),
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isCurrentLocation
                              ? 'MY CURRENT LOCATION'
                              : 'PIN LOCATION',
                          style:
                              TextStyle(color: Color(0xFF707070), fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          trip?.start?.name,
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                )),
            Expanded(
                child: ObinovMap(
              key: _mapKey,
              onLocationChanged: (CameraPosition position) async {
                isCurrentLocation = false;
                Location location =
                    await LocationService.getLocationAddress(position);
                setState(() {
                  trip.setStart(location);
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
