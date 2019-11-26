import 'package:http/http.dart' as http;

abstract class Api {
  static const String BASE_URL = 'base';

  Future<http.Response> get(String url, {Map<String, String> headers});
}

class ApiImpl implements Api {
  final http.Client client;

  ApiImpl(this.client);

  @override
  Future<http.Response> get(String url, {Map<String, String> headers}) {
    return client.get(url, headers: headers);
  }
}

class EndPoints {
  static const number = '/';
  static const random = '/random';
}
