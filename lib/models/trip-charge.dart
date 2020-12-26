import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/trip.dart';

class TripCharge {
  int id;
  int charge;
  int serviceProviderId;
  int tripId;
  int driverId;
  int customerId;
  Trip trip;
  Driver driver;
  Customer customer;
  DateTime createdAt;

  TripCharge({
    this.id,
    this.charge,
    this.serviceProviderId,
    this.tripId,
    this.driverId,
    this.customerId,
    this.trip,
    this.driver,
    this.customer,
    this.createdAt,
  });

  static TripCharge fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return TripCharge(
        id: json['id'],
        tripId: json['tripId'],
        driverId: json['driverId'],
        customerId: json['customerId'],
        serviceProviderId: json['serviceProviderId'],
        charge: json['fare'],
        trip: Trip.fromJson(json['trip']),
        driver: Driver.fromJson(json['driver']),
        customer: Customer.fromJson(json['customer']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );
    } else {
      return null;
    }
  }
}
