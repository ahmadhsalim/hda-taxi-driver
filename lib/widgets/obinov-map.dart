import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ObinovMap extends StatefulWidget {
  final bool myLocationEnabled;
  static const int LOCATION_SELECT_STATE = 0;
  static const int SHOW_DIRECTION_STATE = 1;
  final Function onLocationChanged;
  final CameraPosition cameraPosition;
  final int state;
  final bool selectLocation;

  ObinovMap(
      {Key key,
      this.state = ObinovMap.LOCATION_SELECT_STATE,
      this.onLocationChanged,
      this.cameraPosition,
      this.selectLocation = false,
      this.myLocationEnabled = true})
      : super(key: key);

  @override
  State<ObinovMap> createState() =>
      _ObinovMapState(cameraPosition: cameraPosition);
}

class _ObinovMapState extends State<ObinovMap> {
  bool isAddressLoading = false;
  bool hasCameraMoved = false;
  CameraPosition cameraPosition;
  Completer<GoogleMapController> _controller = Completer();

  _ObinovMapState({this.cameraPosition}) {
    // cameraPosition =
    //     LocationService.getCameraPosition(trip?.start?.getPosition());

    // LocationService.getLocationAddress(cameraPosition);
  }

  Map<MarkerId, Marker> getMarkers() {
    // if (trip == null) return null;

    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    // final MarkerId markerId = MarkerId('marker_id_1');
    // LatLng position = LatLng(
    //   trip.start.latitude,
    //   trip.start.longitude,
    // );

    // if (widget.state == ObinovMap.LOCATION_SELECT_STATE) {
    //   return markers;
    // }

    // final Marker marker = Marker(
    //   markerId: markerId,
    //   position: position,
    //   infoWindow: InfoWindow(title: 'Current Location', snippet: 'Pick-up'),
    // );

    // markers[markerId] = marker;

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    Map<MarkerId, Marker> markerMap = getMarkers();
    Set<Marker> markers;

    if (markerMap != null) {
      markers = Set<Marker>.of(getMarkers().values);
    }

    double appBarHeight = 86;
    double mapWidth = MediaQuery.of(context).size.width;
    double mapHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBarHeight;

    double iconWidth = 39;
    double iconHeight = 53;

    Widget seletionMarker = widget.selectLocation
        ? Positioned(
            top: (mapHeight / 2) - iconHeight,
            right: (mapWidth - iconWidth) / 2,
            child: SvgPicture.asset(
              'assets/location_marker.svg',
              width: iconWidth,
              height: iconHeight,
            ))
        : SizedBox.shrink();

    return Stack(alignment: Alignment(0.0, 0.0), children: <Widget>[
      isAddressLoading ? LinearProgressIndicator() : SizedBox.shrink(),
      Container(
          width: mapWidth,
          height: mapHeight,
          child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: widget.myLocationEnabled,
              initialCameraPosition: cameraPosition,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () => hasCameraMoved = true,
              onCameraMove: (CameraPosition p) {
                if (cameraPosition != null) cameraPosition = p;
              },
              onCameraIdle: () {
                if (widget.selectLocation &&
                    hasCameraMoved &&
                    cameraPosition != null)
                  widget.onLocationChanged(cameraPosition);
              },
              markers: markers)),
      seletionMarker
    ]);
  }
}
