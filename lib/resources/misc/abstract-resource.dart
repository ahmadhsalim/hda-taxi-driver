import 'dart:convert';

import 'package:hda_driver/resources/misc/api-client.dart';
import 'package:hda_driver/resources/misc/base-url.dart';
import 'package:hda_driver/resources/misc/paged-collection.dart';
import 'package:hda_driver/services/identity-service.dart';
import 'package:hda_driver/services/service-locator.dart';
import 'package:http/http.dart';

class AbstractResource {
  Identity identity = getIt<Identity>();

  String get url => null;
  String get host => apiHost;
  String get baseUrl => apiBaseUrl;
  final Function fromJson = null;

  ApiClient client;

  AbstractResource() {
    client = ApiClient(identity.getToken());
  }

  Future find(int id, {params}) async {
    var res = await httpGet("$url/$id", params: params);
    return fromJson(res);
  }

  Future<PagedCollection> paginate({params}) async {
    var res = await httpGet(url, params: params);
    return PagedCollection.fromJson(res, fromJson);
  }

  Future httpGet(String url, {params, Map<String, String> headers}) async {
    Response res = await client
        .get(Uri.http(getUrlPrefix(), baseUrl + url, params), headers: headers);

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  Future httpPut(String url, {data, params}) async {
    Response res = await client.put(
        Uri.http(getUrlPrefix(), baseUrl + url, params),
        body: data == null ? null : json.encode(data));

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  Future httpPost(String url, {data, params}) async {
    Response res = await client.post(
        Uri.http(getUrlPrefix(), baseUrl + url, params),
        body: json.encode(data).toString());

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  String getUrlPrefix() {
    return host;
  }
}
