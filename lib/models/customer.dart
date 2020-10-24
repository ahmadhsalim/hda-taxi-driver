class Customer {
  int id;
  String name;
  String mobile;
  String email;
  String emergencyContact;
  DateTime lastLogin;
  String status;
  String token;

  Customer({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.emergencyContact,
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
        'lastLogin': lastLogin != null ? lastLogin.toString() : null,
        'status': status,
        'token': token,
      };
}
