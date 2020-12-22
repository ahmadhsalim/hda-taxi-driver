import 'dart:convert';

import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';
import 'package:http/http.dart';

class TripResource extends AbstractResource {
  @override
  String get url => "trips";

  @override
  final Function fromJson = Trip.fromJson;

  Future acceptJob(int id, double latitude, double longitude) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/accept"),
      body: {'latitude': latitude, 'longitude': longitude},
    );

    if (res.statusCode == 200) return true;
    return false;
  }

  Future missed(int id) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/missed"),
    );

    if (res.statusCode == 200) return true;
    return false;
  }

  Future cancel(int id) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/cancel"),
    );

    if (res.statusCode == 200) return true;
    return false;
  }

  Future pickUp(int id) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/pick-up"),
    );

    if (res.statusCode == 200) return true;
    return false;
  }

  Future complete(int id) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/complete"),
    );

    if (res.statusCode == 200) return true;
    return false;
  }

  Future rateCustomer(int id, int rating, String comments) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/rate-customer"),
      body: json.encode(
        {
          'rating': rating.toString(),
          'additionalComments': comments,
        },
      ),
    );

    if (res.statusCode == 200) return true;
    return false;
  }
}
