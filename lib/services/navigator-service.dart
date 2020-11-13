import 'package:flutter/widgets.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/resources/driver-resource.dart';
import 'package:hda_driver/resources/misc/resource-collection.dart';
import 'package:hda_driver/routes/constants.dart';
import 'package:hda_driver/screen-arguments/vehicle-reviewing-arguments.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';

Future goToStart(BuildContext context) async {
  DriverResource resource = DriverResource();
  Identity identity = getIt<Identity>();

  try {
    ResourceCollection<Vehicle> collection = await resource.myVehicles();
    if (collection.data.length > 0) {
      if (collection.data[0].isActive()) {
        return Navigator.pushNamedAndRemoveUntil(
            context, homeRoute, (Route<dynamic> route) => false);
      } else {
        Driver driver = await identity.getCurrentDriver(forceAuth: true);
        if (driver.driversLicenseNumber == null) {
          return Navigator.pushNamedAndRemoveUntil(
              context, documentUploadRoute, (Route<dynamic> route) => false);
        } else {
          return Navigator.pushNamedAndRemoveUntil(
              context, vehicleReviewingRoute, (Route<dynamic> route) => false,
              arguments: VehicleReviewingArguments(collection.data[0]));
        }
      }
    } else {
      return Navigator.pushNamedAndRemoveUntil(
          context, addVehicleRoute, (Route<dynamic> route) => false);
    }
  } catch (e) {
    return identity.logout(context);
  }
}
