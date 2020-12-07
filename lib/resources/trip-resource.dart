import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';

class TripResource extends AbstractResource {
  @override
  String get url => "trips";

  @override
  final Function fromJson = Trip.fromJson;
}
