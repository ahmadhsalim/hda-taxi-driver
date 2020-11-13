import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';
import 'package:hda_driver/resources/misc/resource-collection.dart';

class DriverResource extends AbstractResource {
  @override
  String get url => "drivers";

  @override
  final Function fromJson = Driver.fromJson;

  Future<Driver> current({List<String> include}) async {
    var res = await get("$url/me", params: {"include": include?.join(",")});

    return fromJson(res);
  }

  Future<ResourceCollection<Vehicle>> myVehicles({List<String> include}) async {
    var res =
        await get("$url/me/vehicles", params: {"include": include?.join(",")});

    return ResourceCollection.fromJson(res, Vehicle.fromJson);
  }

  Future<bool> updateMe(Driver driver) async {
    var res = await put("$url/me", data: {
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
    var res = await put("$url/me", data: {
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
    var res = await put("$url/me/vehicles/$vehicleId/cancel");

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

    var res = await post("$url/me/vehicles", data: map);
    return Vehicle.fromJson(res);
  }
}
