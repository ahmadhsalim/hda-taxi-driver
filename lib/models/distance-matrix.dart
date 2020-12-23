class DistanceMatrix {
  String destinationAddress;
  String originAddress;

  int distanceValue;
  String distanceText;

  int durationValue;
  String durationText;

  int durationInTrafficValue;
  String durationInTrafficText;

  String status;

  DistanceMatrix({
    this.destinationAddress,
    this.originAddress,
    this.distanceValue,
    this.distanceText,
    this.durationValue,
    this.durationText,
    this.durationInTrafficValue,
    this.durationInTrafficText,
    this.status,
  });

  static DistanceMatrix fromApi(Map<String, dynamic> json) {
    if (json != null) {
      var element = json['rows'][0]['elements'][0];
      return DistanceMatrix(
        destinationAddress: json['destination_addresses'][0],
        originAddress: json['origin_addresses'][0],
        distanceValue: element['distance']['value'],
        distanceText: element['distance']['text'],
        durationValue: element['duration']['value'],
        durationText: element['duration']['text'],
        durationInTrafficValue: element['duration_in_traffic']['value'],
        durationInTrafficText: element['duration_in_traffic']['text'],
        status: json['status'],
      );
    } else {
      return null;
    }
  }

  static DistanceMatrix fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return DistanceMatrix(
        destinationAddress: json['destinationAddress'],
        originAddress: json['originAddress'],
        distanceValue: json['distanceValue'],
        distanceText: json['distanceText'],
        durationValue: json['durationValue'],
        durationText: json['durationText'],
        durationInTrafficValue: json['durationInTrafficValue'],
        durationInTrafficText: json['durationInTrafficText'],
        status: json['status'],
      );
    } else {
      return null;
    }
  }
}
