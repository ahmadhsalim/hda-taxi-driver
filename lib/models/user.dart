
class User {
  int id;
  String name;
  String phone;
  String mobile;
  String email;
  DateTime lastLogin;
  String status;
  String token;

  User({this.id, this.name, this.phone, this.mobile, this.email, this.lastLogin, this.status, this.token});

  static User fromJson(Map<String, dynamic> json) {
    if(json != null) {
      return User(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        mobile: json['mobile'],
        email: json['email'],
        lastLogin: json['lastLogin'] == null ? null : DateTime.parse(json['lastLogin']),
        status: json['status'],
        token: json['token'],
      );
    } else {
      return null;
    }

  }
}