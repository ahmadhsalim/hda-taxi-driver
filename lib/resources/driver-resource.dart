import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/trip-action.dart';
import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';
import 'package:hda_driver/resources/misc/paged-collection.dart';
import 'package:hda_driver/resources/misc/resource-collection.dart';

class DriverResource extends AbstractResource {
  @override
  String get url => "drivers";

  @override
  final Function fromJson = Driver.fromJson;

  Future<Driver> current({List<String> include, String firebaseToken}) async {
    assert(firebaseToken != null);

    var res = await httpGet("$url/me",
        params: {"include": include?.join(",")},
        headers: {'hda-firebase-token': firebaseToken});

    return fromJson(res);
  }

  Future<PagedCollection> myHistory({List<String> include}) async {
    var res = await httpGet("$url/me/history",
        params: {"include": include?.join(",")});

    return PagedCollection.fromJson(res, TripAction.fromJson);
  }

  Future getStats() {
    return httpGet("$url/me/stats");
  }

  Future<ResourceCollection<Vehicle>> myVehicles({List<String> include}) async {
    var res = await httpGet("$url/me/vehicles",
        params: {"include": include?.join(",")});

    return ResourceCollection.fromJson(res, Vehicle.fromJson);
  }

  Future<bool> updateMe(Driver driver) async {
    var res = await httpPut("$url/me", data: {
      'name': driver.name,
      'mobile': driver.mobile,
      'email': driver.email,
    });

    if (res != null)
      return true;
    else
      return false;
  }

  Future<bool> updateDocuments(Driver driver) async {
    var res = await httpPut("$url/me", data: {
      'profilePhoto': driver.profilePhoto,
      'nameOnDriversLicense': driver.nameOnDriversLicense,
      'driversLicenseNumber': driver.driversLicenseNumber,
      'licenseFrontPhoto': driver.licenseFrontPhoto,
      'licenseBackPhoto': driver.licenseBackPhoto,
    });

    if (res != null)
      return true;
    else
      return false;
  }

  Future<bool> cancelVehicle(int vehicleId) async {
    var res = await httpPut("$url/me/vehicles/$vehicleId/cancel");

    if (res != null)
      return true;
    else
      return false;
  }

  Future<Vehicle> addVehicle(Vehicle vehicle) async {
    Map map = {
      'model': vehicle.model,
      'color': vehicle.color,
      'manufacturedYear': vehicle.manufacturedYear,
      'boardNumber': vehicle.boardNumber,
      'plateNumber': vehicle.plateNumber,
      'seats': vehicle.seats,
      'extraLuggage': vehicle.extraLuggage,
      'acceptCashCard': vehicle.acceptCashCard,
      'accessibility': vehicle.accessibility,
      'childSeat': vehicle.childSeat,
      'smoking': vehicle.smoking,
      'vehicleTypeId': vehicle.vehicleTypeId,
    };

    var res = await httpPost("$url/me/vehicles", data: map);
    return Vehicle.fromJson(res);
  }

  Future online() async {
    var res = await httpPut("$url/me/online");
    return res;
  }

  Future offline() async {
    var res = await httpPut("$url/me/offline");
    return res;
  }
}
