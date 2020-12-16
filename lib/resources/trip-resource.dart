import 'dart:convert';

import 'package:hda_driver/models/trip.dart';
import 'package:hda_driver/resources/misc/abstract-resource.dart';
import 'package:http/http.dart';

class TripResource extends AbstractResource {
  @override
  String get url => "trips";

  @override
  final Function fromJson = Trip.fromJson;

  Future acceptJob(int id) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/accept"),
    );

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  Future missed(int id) async {
    Response res = await client.put(
      Uri.http(getUrlPrefix(), baseUrl + "$url/$id/missed"),
    );

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }
}
