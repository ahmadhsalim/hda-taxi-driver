import 'package:hda_app/models/location.dart';
import 'package:hda_app/models/vehicle-type.dart';

class Trip {
  Location start;
  VehicleType vehicleType;
  List<Location> dropOffs = <Location>[];

  setStart(Location location) {
    location.type = 'start';
    start = location;
  }

  setDropOff(Location location) {
    location.type = 'drop-off';
    dropOffs = [location];
  }
}
