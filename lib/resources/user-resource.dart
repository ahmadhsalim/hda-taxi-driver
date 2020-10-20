
import 'package:hda_app/models/user.dart';
import 'package:hda_app/resources/misc/abstract-resource.dart';

class UserResource extends AbstractResource {
  @override
  String get url => "users";

  @override
  final Function fromJson = User.fromJson;

  Future currentRegions() {
    return get("$url/current/regions");
  }

  Future current(List<String> include) {
    return get("$url/current", params: { "include": include.join(",") });
  }
}