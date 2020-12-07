import 'dart:io';

class Customer {
  int id;
  String name;
  String mobile;
  String email;
  String emergencyContact;
  String profilePhoto;
  File profilePhotoFile;
  DateTime lastLogin;
  String status;
  String token;

  Customer({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.emergencyContact,
    this.profilePhoto,
    this.profilePhotoFile,
    this.lastLogin,
    this.status,
    this.token,
  });

  static Customer fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Customer(
        id: json['id'],
        name: json['name'],
        mobile: json['mobile'],
        email: json['email'],
        emergencyContact: json['emergencyContact'],
        profilePhoto: json['profilePhoto'],
        profilePhotoFile: json['profilePhotoFile'],
        lastLogin: json['lastLogin'] == null
            ? null
            : DateTime.parse(json['lastLogin']),
        status: json['status'],
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
        'emergencyContact': emergencyContact,
        'profilePhoto': profilePhoto,
        'lastLogin': lastLogin?.toString(),
        'status': status,
        'token': token,
      };
}
