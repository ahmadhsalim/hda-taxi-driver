
import 'dart:convert';

import 'package:hda_app/resources/misc/api-client.dart';
import 'package:hda_app/resources/misc/base-url.dart';
import 'package:hda_app/resources/misc/paged-collection.dart';
import 'package:hda_app/services/identity-service.dart';
import 'package:hda_app/services/service-locator.dart';

class AbstractResource {

  Identity identity;

  String get url => null;
  String get host => apiHost;
  String get baseUrl => apiBaseUrl;
  final Function fromJson = null;

  ApiClient client;

  AbstractResource() {
    identity = getIt<Identity>();
    client = ApiClient(identity.getToken());
  }

  Future<PagedCollection> paginate({params}) async {
    var res = await get(url, params: params);
    return PagedCollection.fromJson(res, fromJson);
  }


  Future get(String url, {params}) async {
    var res = await client.get(Uri.http(getUrlPrefix(), baseUrl + url,  params));

    if(res.statusCode == 200) return json.decode(res.body);
    return null;
  }

  String getUrlPrefix() {
    return host;
  }
}