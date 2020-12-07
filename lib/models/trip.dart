import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/services/location-service.dart';

class Trip {
  int id;
  String status;
  int serviceProviderId;
  int customerId;
  int driverId;
  int vehicleTypeId;
  Customer customer;
  Driver driver;
  Location start;
  VehicleType vehicleType;
  List<Location> dropOffs = <Location>[];

  Trip({
    this.id,
    this.status,
    this.serviceProviderId,
    this.customerId,
    this.driverId,
    this.vehicleTypeId,
    this.customer,
    this.driver,
    this.start,
    this.vehicleType,
    this.dropOffs,
  });

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

  static Trip fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Trip(
        id: json['id'],
        status: json['status'],
        serviceProviderId: json['serviceProviderId'],
        customerId: json['customerId'],
        driverId: json['driverId'],
        vehicleTypeId: json['vehicleTypeId'],
        customer: Customer.fromJson(json['customer']),
        driver: Driver.fromJson(json['driver']),
        start: Location.fromJson(json['start']),
        vehicleType: VehicleType.fromJson(json['vehicleType']),
        dropOffs: json['dropOffs'] is List
            ? (json['dropOffs'] as List).map((i) {
                return Location.fromJson(i);
              }).toList()
            : [],
      );
    } else {
      return null;
    }
  }
}
