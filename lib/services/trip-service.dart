import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/resources/trip-resource.dart';
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

  Future loadTrip(int id) async {
    TripResource resource = TripResource();
    trip = await resource.find(id,
        params: {'include': 'start,dropOffs,vehicleType.fare,customer'});
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

  Future<bool> acceptJob() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.acceptJob(trip.id);
      if (res == null) return false;
      await loadTrip(trip.id);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future missed() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.missed(trip.id);
      if (res == null) return false;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
