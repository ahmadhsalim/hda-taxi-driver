import 'package:hda_driver/config/variables.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hda_driver/models/location.dart' as HdaLocation;

class LocationService {
  static final double defaultZoom = 16;

  static final CameraPosition defaultPosition = CameraPosition(
    target: LatLng(4.210089, 73.537924),
    zoom: LocationService.defaultZoom,
  );

  static Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .catchError((e) {
      print(e);
    });
  }

  static CameraPosition getCameraPosition(Position position) {
    double latitude;
    double longitude;

    if (position == null) {
      latitude = defaultPosition.target.latitude;
      longitude = defaultPosition.target.longitude;
    } else {
      latitude = position.latitude;
      longitude = position.longitude;
    }

    return CameraPosition(
        target: LatLng(latitude, longitude), zoom: LocationService.defaultZoom);
  }

  static Future<HdaLocation.Location> getLocationAddress(
      CameraPosition position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.target.latitude,
      position.target.longitude,
    );
    Placemark placeMark = placemarks[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String street = placeMark.street;
    String address = '';

    if (name.isNotEmpty) address = name;
    if (street.isNotEmpty) {
      address = address.isEmpty
          ? street
          : street.indexOf(name) == 0
              ? street
              : "$address, $street";
    }
    if (subLocality.isNotEmpty && subLocality != name)
      address = address.isEmpty ? subLocality : "$address, $subLocality";
    print([placeMark, address]);

    return HdaLocation.Location(
      name: address,
      latitude: position.target.latitude,
      longitude: position.target.longitude,
      type: 'location',
    );
  }

  static Future getDistanceTo(HdaLocation.Location destination) async {
    Position here = await LocationService.getCurrentLocation();

    var res = await http.get(Uri.https(
      distanceMatrixUrl,
      distanceMatrixPath,
      {
        'key': distanceMatrixKey,
        'departure_time': 'now',
        'mode': 'driving',
        'units': 'metric',
        'origins': '${here.latitude},${here.longitude}',
        'destinations': '${destination.latitude},${destination.longitude}',
      },
    ));

    return res;
  }
}
