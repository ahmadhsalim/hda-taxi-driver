import 'package:hda_app/models/vehicle.dart';
import 'package:hda_app/resources/misc/abstract-resource.dart';

class VehicleResource extends AbstractResource {
  @override
  String get url => "vehicles";

  @override
  final Function fromJson = Vehicle.fromJson;

  Future onDuty() {
    return get("$url/on-duty");
  }
}
