import 'package:http/http.dart' as http;

class ApiClient extends http.BaseClient {
  final String token;
  final http.Client _inner = http.Client();

  ApiClient(this.token);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['authorization'] = "Bearer $token";
    return _inner.send(request);
  }
}