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
        position.target.latitude, position.target.longitude);
    Placemark placeMark = placemarks[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String thoroughfare = placeMark.thoroughfare;
    String locality = placeMark.locality;
    // String administrativeArea = placeMark.administrativeArea;
    // String postalCode = placeMark.postalCode;
    // String country = placeMark.country;
    // String subThoroughfare = placeMark.subThoroughfare;
    // print(['name', name]);
    // print(['subLocality', subLocality]);
    // print(['locality', locality]);
    // print(['subThoroughfare', subThoroughfare]);
    // print(['thoroughfare', thoroughfare]);
    // print(['', thoroughfare.isEmpty]);

    String address = '';

    if (name.isNotEmpty) {
      if (thoroughfare.isNotEmpty) {
        if (thoroughfare == name)
          address = name;
        else
          address = "$name, $thoroughfare";
      } else {
        address = name;
      }
    } else if (thoroughfare.isNotEmpty) {
      address = thoroughfare;
    } else if (locality.isNotEmpty) {
      address = locality;
    } else {
      address = subLocality;
    }

    return HdaLocation.Location(
        name: address,
        latitude: position.target.latitude,
        longitude: position.target.longitude,
        type: 'location');
    // return {'address': address, 'position': position};
  }
}
