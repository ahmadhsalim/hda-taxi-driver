class Vehicle {
  int id;
  String description;
  String registrationNumber;
  int seats;
  String status;

  Vehicle(
      {this.id,
      this.description,
      this.registrationNumber,
      this.seats,
      this.status});

  static Vehicle fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Vehicle(
        id: json['id'],
        description: json['description'],
        registrationNumber: json['registrationNumber'],
        seats: json['seats'],
        status: json['status'],
      );
    } else {
      return null;
    }
  }
}
