import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/driver.dart';
import 'package:hda_driver/models/trip.dart';

class CustomerRating {
  int id;
  int rating;
  String additionalComments;
  int serviceProviderId;
  int tripId;
  int customerId;
  int ratedById;
  Trip trip;
  Driver ratedBy;
  Customer customer;
  DateTime createdAt;

  CustomerRating({
    this.id,
    this.rating,
    this.additionalComments,
    this.serviceProviderId,
    this.tripId,
    this.customerId,
    this.ratedById,
    this.trip,
    this.ratedBy,
    this.customer,
    this.createdAt,
  });

  static CustomerRating fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return CustomerRating(
        id: json['id'],
        rating: json['rating'],
        additionalComments: json['additionalComments'],
        tripId: json['tripId'],
        customerId: json['customerId'],
        ratedById: json['ratedById'],
        serviceProviderId: json['serviceProviderId'],
        trip: Trip.fromJson(json['trip']),
        ratedBy: Driver.fromJson(json['ratedBy']),
        customer: Customer.fromJson(json['customer']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );
    } else {
      return null;
    }
  }
}
