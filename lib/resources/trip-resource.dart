import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';
import 'package:http/http.dart';

class TripResource extends AbstractResource {
  @override
  String get url => "trips";

  @override
  final Function fromJson = Trip.fromJson;

  Future acceptJob(int id, double latitude, double longitude) async {
    var res = await httpPut(
      "$url/$id/accept",
      data: {'latitude': latitude, 'longitude': longitude},
    );

    if (res == null) return false;
    return true;
  }

  Future missed(int id) async {
    Response res = await httpPut(
      "$url/$id/missed",
    );

    if (res == null) return false;
    return true;
  }

  Future cancel(int id) async {
    Response res = await httpPut(
      "$url/$id/cancel",
    );

    if (res == null) return false;
    return true;
  }

  Future pickUp(int id) async {
    Response res = await httpPut(
      "$url/$id/pick-up",
    );

    if (res == null) return false;
    return true;
  }

  Future complete(int id) async {
    Response res = await httpPut(
      "$url/$id/complete",
    );

    if (res == null) return false;
    return true;
  }

  Future rateCustomer(int id, int rating, String comments) async {
    var res = await httpPut(
      "$url/$id/rate-customer",
      data: {
        'rating': rating.toString(),
        'additionalComments': comments,
      },
    );

    if (res == null) return false;
    return true;
  }
}
