import 'package:hda_driver/models/vehicle-type.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';
import 'package:hda_driver/resources/misc/resource-collection.dart';

class VehicleTypeResource extends AbstractResource {
  @override
  String get url => "vehicle-types";

  @override
  final Function fromJson = VehicleType.fromJson;

  Future<ResourceCollection<VehicleType>> full({params}) async {
    var res = await httpGet("$url/full", params: params);
    return ResourceCollection.fromJson(res, fromJson);
  }
}
