import 'package:hda_driver/models/vehicle.dart';

class Driver {
  int id;
  String name;
  String mobile;
  String email;
  List<Vehicle> vehicles;
  DateTime lastLogin;
  String profilePhoto;
  String nameOnDriversLicense;
  String driversLicenseNumber;
  String licenseFrontPhoto;
  String licenseBackPhoto;
  String status;
  bool onDuty;
  String token;

  Driver({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.vehicles,
    this.lastLogin,
    this.profilePhoto,
    this.nameOnDriversLicense,
    this.driversLicenseNumber,
    this.licenseFrontPhoto,
    this.licenseBackPhoto,
    this.status,
    this.onDuty,
    this.token,
  });

  static Driver fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Driver(
        id: json['id'],
        name: json['name'],
        mobile: json['mobile'],
        email: json['email'],
        vehicles: json['vehicles'] is List
            ? (json['vehicles'] as List).map((i) {
                return Vehicle.fromJson(i);
              }).toList()
            : [],
        lastLogin: json['lastLogin'] == null
            ? null
            : DateTime.parse(json['lastLogin']),
        profilePhoto: json['profilePhoto'],
        nameOnDriversLicense: json['nameOnDriversLicense'],
        driversLicenseNumber: json['driversLicenseNumber'],
        licenseFrontPhoto: json['licenseFrontPhoto'],
        licenseBackPhoto: json['licenseBackPhoto'],
        status: json['status'],
        onDuty: json['onDuty'],
        token: json['token'],
      );
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'email': email,
        'lastLogin': lastLogin != null ? lastLogin.toString() : null,
        'profilePhoto': profilePhoto,
        'nameOnDriversLicense': nameOnDriversLicense,
        'driversLicenseNumber': driversLicenseNumber,
        'licenseFrontPhoto': licenseFrontPhoto,
        'licenseBackPhoto': licenseBackPhoto,
        'status': status,
        'onDuty': onDuty,
        'token': token,
      };
}
