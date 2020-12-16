import 'package:geolocator/geolocator.dart';

class Location {
  int id;
  String name;
  double latitude;
  double longitude;
  String type;

  Location({this.id, this.name, this.latitude, this.longitude, this.type});

  static Location fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Location(
        id: json['id'],
        name: json['name'],
        latitude: double.parse(json['latitude']),
        longitude: double.parse(json['longitude']),
        type: json['type'],
      );
    } else {
      return null;
    }
  }

  Position getPosition() {
    return Position(latitude: latitude, longitude: longitude);
  }
}
