import 'package:hda_app/models/customer.dart';
import 'package:hda_app/resources/misc/abstract-resource.dart';

class CustomerResource extends AbstractResource {
  @override
  String get url => "customers";

  @override
  final Function fromJson = Customer.fromJson;

  Future<Customer> current({List<String> include}) async {
    var res = await get("$url/me", params: {"include": include?.join(",")});

    return fromJson(res);
  }

  Future<bool> updateMe(Customer customer) async {
    var res = await put("$url/me", data: {
      'name': customer.name,
      'mobile': customer.mobile,
      'email': customer.email,
      'emergencyContact': customer.emergencyContact,
    });

    if (res != null)
      return true;
    else
      return false;
  }
}
