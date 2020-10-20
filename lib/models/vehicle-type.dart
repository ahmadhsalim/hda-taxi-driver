import 'package:hda_app/models/fare.dart';

class VehicleType {
  int id;
  String name;
  String icon;
  int seats;
  int fareId;
  Fare fare;
  int serviceProviderId;

  VehicleType(
      {this.id,
      this.name,
      this.icon,
      this.seats,
      this.fareId,
      this.fare,
      this.serviceProviderId});

  static VehicleType fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return VehicleType(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        seats: json['seats'],
        fareId: json['fareId'],
        fare: json['fare'] != null ? Fare.fromJson(json['fare']) : null,
        serviceProviderId: json['serviceProviderId'],
      );
    } else {
      return null;
    }
  }
}
