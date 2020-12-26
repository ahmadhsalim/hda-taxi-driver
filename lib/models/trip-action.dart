import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/fare.dart';
import 'package:hda_driver/models/trip.dart';

class TripAction {
  int id;
  String action;
  Fare fare;
  int serviceProviderId;
  int tripId;
  int driverId;
  Trip trip;
  Driver driver;
  DateTime createdAt;

  TripAction({
    this.id,
    this.action,
    this.fare,
    this.serviceProviderId,
    this.tripId,
    this.driverId,
    this.trip,
    this.driver,
    this.createdAt,
  });

  static TripAction fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return TripAction(
        id: json['id'],
        action: json['action'],
        tripId: json['tripId'],
        driverId: json['driverId'],
        serviceProviderId: json['serviceProviderId'],
        fare: Fare.fromJson(json['fare']),
        trip: Trip.fromJson(json['trip']),
        driver: Driver.fromJson(json['driver']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );
    } else {
      return null;
    }
  }
}
