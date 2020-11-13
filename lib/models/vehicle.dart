import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/vehicle-type.dart';

class Vehicle {
  int id;
  String model;
  String color;
  int manufacturedYear;
  String boardNumber;
  String plateNumber;
  int seats;
  bool extraLuggage;
  bool acceptCashCard;
  bool accessibility;
  bool childSeat;
  bool smoking;
  String status;
  int driverId;
  Driver driver;
  int vehicleTypeId;
  VehicleType vehicleType;

  Vehicle({
    this.id,
    this.model,
    this.color,
    this.manufacturedYear,
    this.boardNumber,
    this.plateNumber,
    this.seats,
    this.extraLuggage = false,
    this.acceptCashCard = false,
    this.accessibility = false,
    this.childSeat = false,
    this.smoking = false,
    this.status,
    this.driverId,
    this.driver,
    this.vehicleTypeId,
    this.vehicleType,
  });

  bool isActive() {
    return status == 'active';
  }

  static Vehicle fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Vehicle(
        id: json['id'],
        model: json['model'],
        color: json['color'],
        manufacturedYear: json['manufacturedYear'],
        boardNumber: json['boardNumber'],
        plateNumber: json['plateNumber'],
        seats: json['seats'],
        extraLuggage: json['extraLuggage'],
        acceptCashCard: json['acceptCashCard'],
        accessibility: json['accessibility'],
        childSeat: json['childSeat'],
        smoking: json['smoking'],
        status: json['status'],
        driverId: json['driverId'],
        driver: json['driver'] == null ? null : Driver.fromJson(json['driver']),
        vehicleTypeId: json['vehicleTypeId'],
        vehicleType: json['vehicleType'] == null
            ? null
            : VehicleType.fromJson(json['vehicleType']),
      );
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'color': color,
        'manufacturedYear': manufacturedYear,
        'boardNumber': boardNumber,
        'plateNumber': plateNumber,
        'seats': seats,
        'extraLuggage': extraLuggage,
        'acceptCashCard': acceptCashCard,
        'accessibility': accessibility,
        'childSeat': childSeat,
        'smoking': smoking,
        'status': status,
        'driverId': driverId,
        'driver': driver != null ? driver.toJson() : null,
        'vehicleTypeId': vehicleTypeId,
        'vehicleType': vehicleType != null ? vehicleType.toJson() : null,
      };
}
