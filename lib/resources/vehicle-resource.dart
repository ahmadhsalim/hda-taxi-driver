import 'package:hda_driver/models/vehicle.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';

class VehicleResource extends AbstractResource {
  @override
  String get url => "vehicles";

  @override
  final Function fromJson = Vehicle.fromJson;

  Future onDuty() {
    return get("$url/on-duty");
  }
}
