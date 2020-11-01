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

  Future<PagedCollection> paginate({params}) async {
    var res = await get(url, params: params);
    return PagedCollection.fromJson(res, fromJson);
  }

  Future get(String url, {params}) async {
    Response res =
        await client.get(Uri.http(getUrlPrefix(), baseUrl + url, params));

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  Future put(String url, {data, params}) async {
    Response res = await client
        .put(Uri.http(getUrlPrefix(), baseUrl + url, params), body: data);

    if (res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  String getUrlPrefix() {
    return host;
  }
}
