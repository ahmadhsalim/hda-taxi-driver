import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/services/location-service.dart';

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

  Location getDropOff() {
    return dropOffs.length > 0 ? dropOffs[dropOffs.length - 1] : null;
  }

  getStartCameraPosition() {
    return LocationService.getCameraPosition(start.getPosition());
  }

  getDropOffCameraPosition() {
    return LocationService.getCameraPosition(getDropOff().getPosition());
  }
}
