import 'package:hda_driver/models/customer-rating.dart';
import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/location.dart';
import 'package:hda_driver/models/trip-charge.dart';
import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/services/location-service.dart';

class Trip {
  int id;
  int customerId;
  int driverId;
  int vehicleTypeId;
  int vehicleId;
  int serviceProviderId;
  String status;
  Customer customer;
  Driver driver;
  VehicleType vehicleType;
  Vehicle vehicle;
  Location start;
  CustomerRating customerRating;
  List<Location> dropOffs = <Location>[];
  List<TripCharge> charges = <TripCharge>[];

  Trip({
    this.id,
    this.status,
    this.serviceProviderId,
    this.customerId,
    this.driverId,
    this.vehicleTypeId,
    this.vehicleId,
    this.customer,
    this.driver,
    this.vehicleType,
    this.vehicle,
    this.start,
    this.customerRating,
    this.dropOffs,
    this.charges,
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
    return dropOffs.length > 0 ? dropOffs.last : null;
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
        vehicleId: json['vehicleId'],
        customer: Customer.fromJson(json['customer']),
        driver: Driver.fromJson(json['driver']),
        vehicleType: VehicleType.fromJson(json['vehicleType']),
        vehicle: Vehicle.fromJson(json['vehicle']),
        start: Location.fromJson(json['start']),
        customerRating: CustomerRating.fromJson(json['customerRating']),
        dropOffs: json['dropOffs'] is List
            ? (json['dropOffs'] as List).map((i) {
                return Location.fromJson(i);
              }).toList()
            : [],
        charges: json['charges'] is List
            ? (json['charges'] as List).map((i) {
                return TripCharge.fromJson(i);
              }).toList()
            : [],
      );
    } else {
      return null;
    }
  }
}
