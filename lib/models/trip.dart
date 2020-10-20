import 'package:hda_app/models/location.dart';

class Trip {
  Location start;
  List<Location> dropOffs = <Location>[];

  setStart(Location location) {
    location.type = 'start';
    start = location;
  }
}
