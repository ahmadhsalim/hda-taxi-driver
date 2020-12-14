import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/resources/trip-resource.dart';

class TripService {
  Trip _trip;

  TripService() {
    // createTrip();
  }

  // TripService createTrip() {
  //   trip = Trip();
  //   trip.start = Location(
  //       name: 'Pick-up',
  //       latitude: LocationService.defaultPosition.target.latitude,
  //       longitude: LocationService.defaultPosition.target.longitude,
  //       type: 'start');
  //   return this;
  // }

  Future loadTrip(int id) async {
    TripResource resource = TripResource();
    _trip = await resource.find(id,
        params: {'include': 'start,dropOffs,vehicleType.fare,customer'});
  }

  Trip getTrip() {
    return _trip;
  }

  clearTrip() {
    _trip = null;
  }

  setStart(Location location) {
    _trip.setStart(location);
  }

  setDropOff(Location location) {
    _trip.setDropOff(location);
  }

  setVehicleType(VehicleType type) {
    _trip.vehicleType = type;
  }

  Future<bool> acceptJob() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.acceptJob(_trip.id);
      if (res == null) return false;
      await loadTrip(_trip.id);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future missed() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.missed(_trip.id);
      if (res == null) return false;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
