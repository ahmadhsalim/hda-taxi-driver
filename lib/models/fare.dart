class Fare {
  int id;
  String type;
  double minimumFare;
  double maximumFare;
  double flagDropFare;
  double perKmFare;
  double perMinuteFare;
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
        minimumFare: json['minimumFare'] / 100,
        maximumFare: json['maximumFare'] / 100,
        flagDropFare: json['flagDropFare'] / 100,
        perKmFare: json['perKmFare'] / 100,
        perMinuteFare: json['perMinuteFare'] / 100,
        serviceProviderId: json['serviceProviderId'],
        status: json['status'],
      );
    } else {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'minimumFare': minimumFare,
        'maximumFare': maximumFare,
        'flagDropFare': flagDropFare,
        'perKmFare': perKmFare,
        'perMinuteFare': perMinuteFare,
        'serviceProviderId': serviceProviderId,
        'status': status,
      };
}
