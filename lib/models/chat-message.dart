import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/driver.dart';

class ChatMessage {
  int id;
  String senderType;
  String message;
  int customerId;
  int driverId;
  int serviceProviderId;
  int tripId;
  String status;
  Customer customer;
  Driver driver;
  DateTime createdAt;

  ChatMessage({
    this.id,
    this.senderType,
    this.message,
    this.customerId,
    this.driverId,
    this.serviceProviderId,
    this.tripId,
    this.status,
    this.customer,
    this.driver,
    this.createdAt,
  });

  static ChatMessage fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return ChatMessage(
        id: json['id'],
        senderType: json['senderType'],
        message: json['message'],
        customerId: json['customerId'],
        driverId: json['driverId'],
        serviceProviderId: json['serviceProviderId'],
        tripId: json['tripId'],
        status: json['status'],
        customer: Customer.fromJson(json['customer']),
        driver: Driver.fromJson(json['driver']),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );
    } else {
      return null;
    }
  }
}
