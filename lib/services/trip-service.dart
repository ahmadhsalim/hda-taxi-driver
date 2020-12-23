import 'dart:io';

import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/resources/file-resource.dart';
import 'package:hda_driver/resources/trip-resource.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';

class TripService {
  Trip _trip;
  File customerPhoto;

  // TripService();

  Future loadTrip(int id) async {
    Identity identity = getIt<Identity>();
    FileResource fileResource = FileResource(identity.getToken());
    TripResource resource = TripResource();
    _trip = await resource.find(id,
        params: {'include': 'start,dropOffs,vehicleType.fare,customer'});
    if (_trip != null) {
      if (_trip.customer.profilePhoto != null) {
        try {
          String photoPath = await fileResource.fileDownload(
              fileName: _trip.customer.profilePhoto);
          if (photoPath != null) {
            customerPhoto = File(photoPath);
            _trip.customer.profilePhotoFile = customerPhoto;
          }
        } catch (e) {
          print('Unable to download customer photo');
        }
      }
    }
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

  Future<bool> acceptJob(double latitude, double longitude) async {
    try {
      TripResource resource = TripResource();
      var res = await resource.acceptJob(_trip.id, latitude, longitude);
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

      clearTrip();
      if (res == null) return false;

      return true;
    } catch (e) {
      print(e);
      clearTrip();
      return false;
    }
  }

  Future cancel() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.cancel(_trip.id);
      clearTrip();

      if (res == null) return false;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future pickUp() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.pickUp(_trip.id);

      if (res == null) return false;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future complete() async {
    try {
      TripResource resource = TripResource();
      var res = await resource.complete(_trip.id);

      if (res == null) return false;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future rateCustomer(int rating, String comments) async {
    try {
      TripResource resource = TripResource();
      await resource.rateCustomer(_trip.id, rating, comments);
    } catch (e) {
      print(e);
    }
  }
}
