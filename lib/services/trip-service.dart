import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/services/location-service.dart';

class TripService {
  Trip trip;

  TripService() {
    createTrip();
  }

  TripService createTrip() {
    trip = Trip();
    trip.start = Location(
        name: 'Pick-up',
        latitude: LocationService.defaultPosition.target.latitude,
        longitude: LocationService.defaultPosition.target.longitude,
        type: 'start');
    return this;
  }

  setStart(Location location) {
    trip.setStart(location);
  }

  setDropOff(Location location) {
    trip.setDropOff(location);
  }

  setVehicleType(VehicleType type) {
    trip.vehicleType = type;
  }
}
