class Fare {
  int id;
  String type;
  int minimumFare;
  int maximumFare;
  int flagDropFare;
  int perKmFare;
  int perMinuteFare;
  int serviceProviderId;
  String status;

  Fare({
    this.id,
    this.type,
    this.minimumFare,
    this.maximumFare,
    this.flagDropFare,
    this.perKmFare,
    this.perMinuteFare,
    this.serviceProviderId,
    this.status,
  });

  static Fare fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Fare(
        id: json['id'],
        type: json['type'],
        minimumFare: json['minimumFare'],
        maximumFare: json['maximumFare'],
        flagDropFare: json['flagDropFare'],
        perKmFare: json['perKmFare'],
        perMinuteFare: json['perMinuteFare'],
        serviceProviderId: json['serviceProviderId'],
        status: json['status'],
      );
    } else {
      return null;
    }
  }
}
