import 'dart:io';

import 'package:hda_driver/models/customer.dart';
import 'package:hda_driver/models/trip.dart';

class ChatArguments {
  final Trip trip;
  final Customer customer;
  final File customerPhoto;

  ChatArguments(this.trip, this.customer, this.customerPhoto);
}
